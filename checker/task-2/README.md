## Task 2 - Events

To manage his events without using Instagram, Alex decided to automate the
generation of event dates, but unfortunately he is not the ultimate engineer
yet, so some of the events are invalid. Help him check which events are invalid
and sort them by different attributes.

There are two structures used for this task, which are both packed:

```c
    struct date {
        uint8_t day;
        uint8_t month;
        uint16_t year;
    };

    struct event {
        char name[31];
        uint8_t valid;
        struct date date;
    };
```

### Subtask 1

For this subtask, you have to check if the date of each event is valid, based
on the next rules:

- The year should be between 1990 and 2030
- The month should be between 1 and 12
- The day should be between 1 and the last day of each month (e.g. for January the last day is 31, for February, it is 28)

If a date is valid, set the `valid` flag in the `event` structure to 1 (True), to 0 (False) otherwise.

The function definition is:

```c
void check_events(struct event *events, int len);
```

The arguments are:

- **events:** start address of the events array
- **len:** number of events in the array

### Subtask 2

For this subtask, you have to sort the events resulted after the first subtask
following the next steps while comparing two events:

- if an event is valid, it is **not** considered greater, which means all the valid events should come first
- if two events are valid, they should be sorted by their date, by year, then by month, then by date
- if the dates of two events are equal, they should be sorted like using `strcmp()` function by their name and using its result, so if the result is negative, it means the first name should come first in the sorted array

The sorting should be done **in place**, that means that the array given as input should contain the sorted
events and that is what will be checked.

The function definition is:

```c
void sort_events(struct event *events, int len);
```

The arguments are:

- **events:** start address of the events array
- **len:** number of events in the array

**All the data in the structures will be limited to their data type size and the name of the events is unique!**

#### **Important Notice**

For the second subtask will be used the same array given as input in the first subtask, this means that any wrong modifications of the structures during the first subtask will affect the second task and it will result in a failed test. The second subtask can not be completed without completing the first subtask.

---
