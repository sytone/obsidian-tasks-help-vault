# Basic SQL Queries

```toc 
```

Compared to the previous query language the new X version is more complex and powerful. There are a couple of key differences:

- The language is SQL based, if you know SQL you can use pretty much any query you can use in SQL. Please create an issue [here](https://github.com/sytone/obsidian-tasks-x/issues) if you hit a problem.
- If you want to make a fully custom query you need to select all the columns `*` at the moment unless you are grouping by. Selection of individual fields to generate a table is a future feature.

By default you should only need the conditions of the SQL query, that is everything after the `WHERE` clause including the `WHERE` for example `WHERE status->indicator != "x" AND path LIKE '%Journal%' LIMIT 10` which will return all tasks not completed (`x`) with `Journal` in the path.

## Example Simple Queries
These match the ones shows on the examples page for the simple Tasks query model.

### All open tasks that are due today

    ```tasks
    WHERE status->indicator = ' ' AND  moment()->[format]('YYYY-MM-DD') = moment(dueDate)->[format]('YYYY-MM-DD')
    ```

```task-sql
WHERE status->indicator = ' ' AND  moment()->[format]('YYYY-MM-DD') = moment(dueDate)->[format]('YYYY-MM-DD')
```
---
### All open tasks that are due within the next two weeks, but are not overdue (due today or later):
    ```task-sql
    WHERE status->indicator = ' ' AND moment(dueDate)->isBetween(moment()->startOf('day').subtract(1, 'days'), moment()->startOf('day').add(14, 'days'))
    ```
    
```task-sql
WHERE status->indicator = ' ' AND moment(dueDate)->isBetween(moment()->startOf('day').subtract(1, 'days'), moment()->startOf('day').add(14, 'days'))
```
---
### All done tasks that are anywhere in the vault under a `tasks` heading (e.g. `## Tasks`):
    ```task-sql
    WHERE status->indicator = 'x' AND precedingHeader LIKE '%tasks%'
    ```
    
```task-sql
WHERE status->indicator = 'x' AND precedingHeader LIKE '%tasks%'
```
---
### Show all tasks that aren’t done, are due on the 9th of April 2021, and where the path includes `GitHub`
    ```task-sql
    WHERE status->indicator = ' ' 
    AND moment(dueDate)->[format]('YYYY-MM-DD') = '2021-04-09'
    AND path LIKE '%GitHub%'
    ```
    
```task-sql
WHERE status->indicator = ' ' 
AND moment(dueDate)->[format]('YYYY-MM-DD') = '2021-04-09'
AND path LIKE '%GitHub%'
```
---
### All tasks with waiting, waits or wartet
    ```task-sql
    WHERE description LIKE '%waiting%' OR description LIKE '%waits%' OR description LIKE '%wartet%'
    #short
    ```
    
```task-sql
WHERE description LIKE '%waiting%' OR description LIKE '%waits%' OR description LIKE '%wartet%'
#short
```
---
### All tasks with 'trash' in the description

    ```task-sql
    WHERE description LIKE '%trash%'
    ```


```task-sql
WHERE description LIKE '%trash%'
```




Look at the [SQL Compatibility](https://github.com/AlaSQL/alasql/wiki/SQL%20keywords) table to see what SQL commands are supported.

### Object Properties & Functions

Object property

- a -> b
- a -> b -> c

Array member

- a -> 1
- a -> 1 -> 2

Calculated property name

- a -> (1+2)
- a -> ("text2 + " " + "more")

Functions

- myTime -> getFullYear()
- s -> substr(1,2)

-
JavaScript string functions can also be used

`SELECT s->length FROM mytext`

## Grouping

To group you need to specify the field and then `ARRAY(_) AS tasks` this will be more flexible over time but to get parity with the existing Tasks plugin it is constrained.

```SQL
SELECT status, ARRAY(_) AS tasks FROM Tasks GROUP BY status
```