#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

#define OUTPUT_PTS ".................."

struct date {
    uint8_t day;
    uint8_t month;
    uint16_t year;
} __attribute__((packed));

struct event {
    char name[31];
    uint8_t valid;
    struct date date;
} __attribute__((packed));

int tests_num, types_num;
float *type_score;

void check_events(struct event *events, int len);
void sort_events(struct event *events, int len);

void readConfig(char *filename)
{
    FILE *config = fopen(filename, "r");

    fscanf(config, "tests_num: %d\n", &tests_num);
    fscanf(config, "types: %d\n", &types_num);
    type_score = malloc(types_num * sizeof(float));

    char *test_string = malloc(40);

    for (int i = 0; i < types_num; i++) {
        sprintf(test_string, "type %d: ", i + 1);
        fscanf(config, strcat(test_string, "%f\n"), &type_score[i]);
    }
}

int readInput(char *filename, struct event **events_arr)
{
    FILE *input = fopen(filename, "r");
    int len;

    /* read requests */
    fscanf(input, "%d\n", &len);
    *events_arr = malloc(len * sizeof(struct event));
    for(int i = 0 ; i < len ; i++) {
        fscanf(input, "%s %hhu %hhu %hu\n", (*events_arr)[i].name,
            &((*events_arr)[i].date.day),
            &((*events_arr)[i].date.month),
            &((*events_arr)[i].date.year));
    }
    fclose(input);

    return len;
}

void readRef(char *filename, int len, struct event *ref_events)
{
    FILE *ref = fopen(filename, "r");

    for(int i = 0 ; i < len; i++) {
        fscanf(ref, "%s %hhu %hhu %hhu %hu\n", ref_events[i].name,
            &ref_events[i].valid,
            &ref_events[i].date.day,
            &ref_events[i].date.month,
            &ref_events[i].date.year);
    }

    fclose(ref);
}

void printOutput(char *filename, int len, struct event *out_events)
{
    FILE *output = fopen(filename, "w");

    for (int i = 0; i < len; i++) {
        fprintf(output, "%s %hhu %hhu %hhu %hu\n", out_events[i].name,
            out_events[i].valid,
            out_events[i].date.day,
            out_events[i].date.month,
            out_events[i].date.year);
    }

    fclose(output);
}

void printScore(float *check_tests_score, float *sort_tests_score)
{
    float score = 0.0;

    printf("-------------CHECK TESTS-------------\n\n");
    for (int i = 0; i < tests_num; i++) {
        if (check_tests_score[i]) {
            printf("Test %d%.*sPASSED: %.2fp\n", i + 1, i + 1 < 10 ? 18 : 17,
                OUTPUT_PTS, check_tests_score[i]);
        } else {
            printf("Test %d%.*sFAILED: 0.0p\n", i + 1, i + 1 < 10 ? 18 : 17,
                OUTPUT_PTS);
        }
        score += check_tests_score[i];
    }
    printf("\n");

    printf("-------------SORT TESTS--------------\n\n");
    for (int i = 0; i < tests_num; i++) {
        if (sort_tests_score[i]) {
            printf("Test %d%.*sPASSED: %.2fp\n", i + 1, i + 1 < 10 ? 18 : 17,
                OUTPUT_PTS, sort_tests_score[i]);
        } else {
            printf("Test %d%.*sFAILED: 0.0p\n", i + 1, i + 1 < 10 ? 18 : 17,
                OUTPUT_PTS);
        }
        score += sort_tests_score[i];
    }

    printf("\nTASK 2 SCORE: %.2f / 30.00\n", score);
}

int compare_structs(struct event *first, struct event *second)
{
    int name_cmp = strcmp(first->name, second->name);

    if (first->valid != second->valid ||
        first->date.year != second->date.year ||
        first->date.month != second->date.month ||
        first->date.day != second->date.day ||
        name_cmp) {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv)
{
    int len = 0;
    float score = 0;

    readConfig(".config");
    float check_tests_score[tests_num], sort_tests_score[tests_num];

    struct event *events = NULL, *ref_events = NULL;
    char input_file[30], output_file[30], ref_file[30];

    printf("---------------TASK 2---------------\n\n");
    for (int i = 0; i < tests_num; i++) {
        /* read input */
        sprintf(input_file, "./input/events_%d.in", i + 1);
        len = readInput(input_file, &events);

        /* read ref */
        sprintf(ref_file, "./ref/events_%d.ref", i + 1);
        ref_events = malloc(len * sizeof(*ref_events));
        readRef(ref_file, len, ref_events);

        int sort_ok = 1, check_dates_ok = 1;

        check_events(events, len);
        for (int j = 0; j < len; j++) {
            for (int k = 0; k < len; k++) {
                if (!strcmp(events[j].name, ref_events[k].name) &&
                    events[j].valid != ref_events[k].valid) {
                    check_dates_ok = 0;
                }
            }
        }

        sort_events(events, len);
        for (int j = 0; j < len; j++) {
            if (compare_structs(&events[j], &ref_events[j])) {
                sort_ok = 0;
            }
        }

        check_tests_score[i] = check_dates_ok ? type_score[0] : 0;
        sort_tests_score[i] = sort_ok ? type_score[1] : 0;

        sprintf(output_file, "./output/events_%d.out", i + 1);
        printOutput(output_file, len, events);
    }

    printScore(check_tests_score, sort_tests_score);

    return 0;
}
