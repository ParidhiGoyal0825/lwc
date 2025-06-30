import { LightningElement, track } from 'lwc';

export default class TodoTask extends LightningElement {
    @track tasks = [];
    newTask = '';
    taskId = 0;

    handleInput(event) {
        this.newTask = event.target.value;
    }

    addTask() {
        if (this.newTask.trim() === '') return;

        this.tasks = [
            ...this.tasks,
            { id: this.taskId++, name: this.newTask }
        ];
        this.newTask = '';
    }

    handleDelete(event) {
        const taskId = parseInt(event.currentTarget.dataset.id, 10);
        this.tasks = this.tasks.filter(task => task.id !== taskId);
    }
}