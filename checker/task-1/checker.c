#include <stdio.h>

#define NO_TASKS 10

extern void remove_numbers(int *a, int n, int *target, int *ptr_len);

void readInput(char *filename, int *a, int *ptr_n)
{
	FILE *input = fopen(filename, "r");

	fscanf(input, "%d", ptr_n);
	for (int i = 0; i < (*ptr_n); ++i) {
		fscanf(input, "%d", &a[i]);
	}

	fclose(input);
}

void readRef(char *filename, int *ref_buffer, int *ptr_ref_n)
{
	FILE *ref = fopen(filename, "r");
	int ref_num;

	fscanf(ref, "%d", ptr_ref_n);
	for (int i = 0; i < (*ptr_ref_n); ++i) {
		fscanf(ref, "%d", &ref_buffer[i]);
	}
	fclose(ref);
}

void printOutput(char *filename, int *out_buffer, int out_n)
{
	FILE *output = fopen(filename, "w");

	fprintf(output, "%d\n", out_n);
	for (int i = 0; i < out_n; ++i) {
		fprintf(output, "%d ", out_buffer[i]);
	}
	fprintf(output, "\n");

	fclose(output);
}

void sort(int *buffer, int n)
{
	for (int i = 0; i < n; ++i) {
		int min_pos = i;

		for (int j = i + 1; j < n; ++j) {
			if (buffer[j] < buffer[min_pos]) {
				min_pos = j;
			}
		}

		int tmp = buffer[i];
		buffer[i] = buffer[min_pos];
		buffer[min_pos] = tmp;
	}
}

int check(int *out_buffer, int out_n, int *ref_buffer, int ref_n)
{
	if (out_n != ref_n) {
		return 0;
	}

	sort(out_buffer, out_n);
	sort(ref_buffer, ref_n);

	for (int i = 0; i < out_n; ++i) {
		if (out_buffer[i] != ref_buffer[i]) {
			return 0;
		}
	}

	return 1;
}

int main(int argc, char **argv)
{
	float score = 0;
	unsigned int x, ref;
	char input_file[30], output_file[30], ref_file[30];

	printf("--------------TASK 1--------------\n");

	int in_buffer[256], out_buffer[256], ref_buffer[256];
	int in_n, out_n = 0, ref_n;

	for (int i = 0; i < NO_TASKS; i++) {
		/* read input */
		sprintf(input_file, "./input/remove_%d.in", i + 1);
		sprintf(ref_file, "./ref/remove_%d.ref", i + 1);

		readInput(input_file, in_buffer, &in_n);
		readRef(ref_file, ref_buffer, &ref_n);

		remove_numbers(in_buffer, in_n, out_buffer, &out_n);

		sprintf(output_file, "./output/remove_%d.out", i + 1);
		printOutput(output_file, out_buffer, out_n);

		if (check(out_buffer, out_n, ref_buffer, ref_n)) {
			printf("Test %02d.................PASSED: %.1fp\n", i + 1, 1.5);
			score += 1.5;
		}
		else {
			printf("Test %02d.................FAILED: %.1fp\n", i + 1, 0.0);
		}
	}

	printf("\nTASK 1 SCORE: %.2f / 15.00\n\n", score);

	return 0;
}