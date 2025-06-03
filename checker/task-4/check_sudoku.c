#include <stdio.h>
#include <stdlib.h>

#define NUM_TESTS 10
#define TASK_VALUE 20.0

int check_row(char* sudoku, int row);
int check_column(char* sudoku, int column);
int check_box(char* sudoku, int box);

void load_test(unsigned int test_no, char* sudoku) {
    FILE* file;
    char file_name[30];

    sprintf(file_name, "./input/test_%d.in", test_no);

    file = fopen(file_name, "r");

    for (size_t j = 0; j < 9; j++) {
        for (size_t i = 0; i < 9; i++) {
            fscanf(file, "%hhd", &(sudoku[i + j * 9]));
        }
    }

    fclose(file);
}

/// @brief Check user results for a given test
/// @param test_no Which test
/// @param row_results User's results from `check_row`
/// @param col_results User's results from `check_column`
/// @param box_results User's results from `check_box`
/// @return How many points they've earned
double check_result(int test_no, int* row_results, int* col_results, int* box_results) {
    char ref_filename[30];
    FILE* ref_file;

    sprintf(ref_filename, "./ref/test_%d.ref", test_no);
    ref_file = fopen(ref_filename, "r");

    int correct_row[9];
    int correct_col[9];
    int correct_box[9];

    for (size_t i = 0; i < 9; i++) {
        fscanf(ref_file, "%d", &(correct_row[i]));
    }
    for (size_t i = 0; i < 9; i++) {
        fscanf(ref_file, "%d", &(correct_col[i]));
    }
    for (size_t i = 0; i < 9; i++) {
        fscanf(ref_file, "%d", &(correct_box[i]));
    }

    int matches_row = 1;
    int matches_col = 1;
    int matches_box = 1;

    for (size_t i = 0; i < 9; i++) {
        if (correct_row[i] != row_results[i]) {
            matches_row = 0;
            break;
        }
    }
    for (size_t i = 0; i < 9; i++) {
        if (correct_col[i] != col_results[i]) {
            matches_col = 0;
            break;
        }
    }
    for (size_t i = 0; i < 9; i++) {
        if (correct_box[i] != box_results[i]) {
            matches_box = 0;
            break;
        }
    }

    int points_unscaled = matches_row + matches_box + matches_col;
    double points = ((double)points_unscaled) / 3 * (double)TASK_VALUE / (double)NUM_TESTS;

    if (points_unscaled == 3) {
        printf("Test %d.................PASSED: %.2fp\n", test_no, points);
    } else if (points_unscaled != 0) {
        printf("Test %d................PARTIAL: %.2fp\n", test_no, points);
    } else {
        printf("Test %d.................FAILED: %.2fp\n", test_no, 0.0);
    }

    fclose(ref_file);
    return points;
}

void write_out(int test_no, int* row_results, int* col_results, int* box_results) {
    char out_filename[30];
    FILE* out_file;

    sprintf(out_filename, "./output/test_%d.out", test_no);
    out_file = fopen(out_filename, "w");

    for (size_t i = 0; i < 8; i++) {
        fprintf(out_file, "%d ", row_results[i]);
    }
    fprintf(out_file, "%d\n", row_results[8]);

    
    for (size_t i = 0; i < 8; i++) {
        fprintf(out_file, "%d ", col_results[i]);
    }
    fprintf(out_file, "%d\n", col_results[8]);


    for (size_t i = 0; i < 8; i++) {
        fprintf(out_file, "%d ", box_results[i]);
    }
    fprintf(out_file, "%d\n", box_results[8]);

    fclose(out_file);
}

int main() {
    double score = 0.0;
    char sudoku[9 * 9] = {0};

    printf("--------------TASK 4--------------\n");

    for (size_t test_no = 0; test_no < NUM_TESTS; test_no++) {
        load_test(test_no, sudoku);

        int user_rows[9] = {0};
        int user_cols[9] = {0};
        int user_boxes[9] = {0};

        for (size_t i = 0; i < 9; i++) {
            user_rows[i] = check_row(sudoku, i);
            user_cols[i] = check_column(sudoku, i);
            user_boxes[i] = check_box(sudoku, i);
        }

        write_out(test_no, user_rows, user_cols, user_boxes);
        

        score += check_result(test_no, user_rows, user_cols, user_boxes);
    }
    printf("\nTASK 4 SCORE: %.2f / %.2f\n\n", score, TASK_VALUE);

    return 0;
}
