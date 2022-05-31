## Available Columns

The following columns are available to be used in the `WHERE` clauses to increase the flexibility of your searches. 

| Column Name                 | Description                                                                                     | Example                                              | Type     |
| --------------------------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------- | -------- |
| status->indicator           | The value between the square brackets.                                                          | 'x', ' ', '-', '/'                                   | String   |
| status->name                | The display name for the status.                                                                | 'Done', 'Todo', 'Cancelled', 'In Progress'           | String   |
| status->nextStatusIndicator | The next indicator to be used when clicked on.                                                  | 'x', ' ', '/', etc                                   | String   |
| description                 | The description of the task.                                                                    | Feed the dog                                         | String   |
| path                        | The path to the note the task is in.                                                            | 01 Journal/2022/2022-12/2022-12-25                   | String   |
| precedingHeader             | The heading that the task is under.                                                             | Party Preparations                                   | String   |
| priority                    | The priority of the task. This has to be treated like a string ('1', '2', '3', '4')             | '1', '2', '3', '4'                                   | String   |
| startDate                   | The date you want to start seeing the task and it can be worked on.                             | 2022-06-22                                           | Date     |
| scheduledDate               | The date that you plan to start working on the task.                                            | 2022-06-22                                           | Date     |
| dueDate                     | The date when the task must be done.                                                            | 2022-06-22                                           | Date     |
| createdDate                 | The date when the task was created on the note                                                  | 2022-06-22                                           | Date     |
| doneDate                    | The date when the task was ticked in Obsidian                                                   | 2022-06-22                                           | Date     |
| recurrence->baseOnToday     | When the reoccurring task has 'when done' on the end and the reoccurrence is from the done date | false                                                | Boolean  |
| recurrence->dueDate         | The date when the task must be done.                                                            | 2022-06-22                                           | Date     |
| recurrence->referenceDate   | The day to calculate the reoccurrence from.                                                     | 2022-06-22                                           | Date     |
| recurrence->rrule           | The raw recurrence pattern.                                                                     | DTSTART:20210425T000000Z\nRRULE:FREQ=WEEKLY;BYDAY=SU | String   |
| recurrence->scheduledDate   | The date that you plan to start working on the task.                                            | 2022-06-22                                           | Date     |
| recurrence->startDate       | The date you want to start seeing the task and it can be worked on.                             | 2022-06-22                                           | Date     |
| blockLink                   | The blocklink in Obsidian for the task.                                                         | `^myblocklink`                                        | String   |
| tags                        | Collection of tags associated with the task.                                                    | ['#tag1','#tagtwo/child']                            | String[] |


### Date Columns

When using the date columns you can use javascript commands in the WHERE clause. The example below will pull all tasks that were done in 2021. You can also use [Moment.js](https://momentjs.com/) functions in the query as well. 

````markdown
```task-sql
WHERE ((dueDate->getUTCFullYear() = 2021 AND status->indicator = 'x') OR (dueDate->getUTCFullYear() = 2022 AND status->indicator = ' ')) AND description LIKE '%#%'
```
````
