import { LightningElement, api, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/ChartJS';
import getOpportunityData from '@salesforce/apex/OpportunityChartController.getOpportunityData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let Chart;

export default class opportunityCharts extends LightningElement {
    @api recordId;

    @track previousQuarterData;
    @track upcomingQuarterData;
    @track loading = true;
    @track errorMessage;

    chartLoaded = false;
    previousChartInstance;
    upcomingChartInstance;

    connectedCallback() {
        if (!this.chartLoaded) {
            loadScript(this, CHARTJS)
                .then(() => {
                    ChartLibrary = window.Chart;
                    this.chartLoaded = true;
                    this.initializeCharts();
                })
                .catch(err => this.handleError('Chart.js Load Error', err));
        }
    }

    renderedCallback() {
        if (this.chartLoaded && this.previousQuarterData && this.upcomingQuarterData) {
            if (!this.previousChartInstance || !this.upcomingChartInstance) {
                this.renderChartViews();
            }
        }
    }

    async initializeCharts() {
        this.loading = true;
        try {
            const result = await getOpportunityData({ accountId: this.recordId });

            this.buildPreviousQuarterData(result.lastQuarterOpportunities);
            this.buildUpcomingQuarterData(result.nextQuarterOpportunities);

            this.loading = false;
        } catch (err) {
            this.handleError('Data Fetch Error', err);
        }
    }

    buildPreviousQuarterData(opps) {
        const stageMap = new Map();

        for (const { StageName } of opps) {
            stageMap.set(StageName, (stageMap.get(StageName) || 0) + 1);
        }

        const labels = [...stageMap.keys()];
        const values = [...stageMap.values()];
        const colors = labels.map((_, i) => `hsl(${(i * 45) % 360}, 60%, 65%)`);

        this.previousQuarterData = {
            labels,
            datasets: [{
                data: values,
                backgroundColor: colors,
                hoverOffset: 4
            }]
        };
    }

    buildUpcomingQuarterData(opps) {
        const high = opps.filter(o => o.Probability >= 70).length;
        const low = opps.filter(o => o.Probability < 70).length;

        this.upcomingQuarterData = {
            labels: ['High Probability', 'Low Probability'],
            datasets: [{
                data: [high, low],
                backgroundColor: ['#4CAF50', '#FFC107'],
                hoverOffset: 4
            }]
        };
    }

    renderChartViews() {
        this.previousChartInstance?.destroy();
        this.upcomingChartInstance?.destroy();

        const previousCtx = this.template.querySelector('.chart-previous-quarter');
        const upcomingCtx = this.template.querySelector('.chart-upcoming-quarter');

        if (previousCtx && upcomingCtx) {
            this.previousChartInstance = new ChartLibrary(previousCtx, {
                type: 'pie',
                data: this.previousQuarterData,
                options: this.chartOptions('Opportunities by Stage (Last Quarter)')
            });

            this.upcomingChartInstance = new ChartLibrary(upcomingCtx, {
                type: 'pie',
                data: this.upcomingQuarterData,
                options: this.chartOptions('Opportunity Probability Forecast')
            });
        }
    }

    chartOptions(titleText) {
        return {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                title: { display: true, text: titleText }
            }
        };
    }

    get chartsReady() {
        return this.previousQuarterData && this.upcomingQuarterData;
    }

    handleError(header, error) {
        this.loading = false;
        this.errorMessage = error?.body?.message || error.message || 'Unexpected error occurred';
        this.dispatchEvent(new ShowToastEvent({
            title: header,
            message: this.errorMessage,
            variant: 'error'
        }));
    }
}