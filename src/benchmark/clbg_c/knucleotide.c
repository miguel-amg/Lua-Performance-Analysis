#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <omp.h>

// Same definitions as your original code...
#define HASHSIZE 262144

typedef struct Node {
    char *key;
    int value;
    struct Node *next;
} Node;

typedef struct {
    Node **table;
} HashTable;

HashTable *create_table() {
    HashTable *new_table = malloc(sizeof(HashTable));
    new_table->table = malloc(sizeof(Node*) * HASHSIZE);
    memset(new_table->table, 0, sizeof(Node*) * HASHSIZE);
    return new_table;
}

uint32_t hash(const char *key) {
    uint32_t h = 0;
    while (*key) {
        h = h * 101 + *key++;
    }
    return h % HASHSIZE;
}

void add_to_table(HashTable *ht, const char *key, int value) {
    uint32_t h = hash(key);
    Node *node = ht->table[h];
    while (node) {
        if (strcmp(node->key, key) == 0) {
            node->value += value;
            return;
        }
        node = node->next;
    }
    node = malloc(sizeof(Node));
    node->key = strdup(key);
    node->value = value;
    node->next = ht->table[h];
    ht->table[h] = node;
}

int get_from_table(HashTable *ht, const char *key) {
    uint32_t h = hash(key);
    Node *node = ht->table[h];
    while (node) {
        if (strcmp(node->key, key) == 0) {
            return node->value;
        }
        node = node->next;
    }
    return 0;
}

void free_table(HashTable *ht) {
    for (int i = 0; i < HASHSIZE; i++) {
        Node *node = ht->table[i];
        while (node) {
            Node *tmp = node;
            node = node->next;
            free(tmp->key);
            free(tmp);
        }
    }
    free(ht->table);
    free(ht);
}

// Reading and encoding the input...
char* read_input_fasta_sequence_THREE(size_t *length) {
    char *line = NULL;
    size_t size = 0;
    ssize_t len;
    char *sequence = NULL;
    size_t cap = 1024, n = 0;
    sequence = malloc(cap);
    int capture = 0;

    while ((len = getline(&line, &size, stdin)) != -1) {
        if (line[0] == '>') {
            capture = (strstr(line, "THREE") != NULL);
        } else if (capture) {
            for (ssize_t i = 0; i < len; i++) {
                if (isalpha(line[i])) {
                    if (n >= cap) {
                        cap *= 2;
                        sequence = realloc(sequence, cap);
                    }
                    sequence[n++] = toupper(line[i]);
                }
            }
        }
    }
    free(line);
    *length = n;
    return sequence;
}

void generate_Frequencies_For_Sequences(char *seq, size_t len, int k) {
    HashTable *table = create_table();
    char *kmer = malloc(k + 1);
    kmer[k] = '\0';

    for (size_t i = 0; i <= len - k; i++) {
        memcpy(kmer, &seq[i], k);
        add_to_table(table, kmer, 1);
    }

    // Count total for percentages
    int total = 0;
    for (int i = 0; i < HASHSIZE; i++) {
        for (Node *node = table->table[i]; node; node = node->next) {
            total += node->value;
        }
    }

    // Collect into array for sorting
    typedef struct {
        char *key;
        int value;
    } Entry;

    int entry_cap = 1024;
    int entry_count = 0;
    Entry *entries = malloc(sizeof(Entry) * entry_cap);

    for (int i = 0; i < HASHSIZE; i++) {
        for (Node *node = table->table[i]; node; node = node->next) {
            if (entry_count >= entry_cap) {
                entry_cap *= 2;
                entries = realloc(entries, sizeof(Entry) * entry_cap);
            }
            entries[entry_count].key = node->key;
            entries[entry_count].value = node->value;
            entry_count++;
        }
    }

    // Sort
    int cmp(const void *a, const void *b) {
        const Entry *ea = a, *eb = b;
        if (eb->value != ea->value)
            return eb->value - ea->value;
        return strcmp(ea->key, eb->key);
    }
    qsort(entries, entry_count, sizeof(Entry), cmp);

    // Output
    for (int i = 0; i < entry_count; i++) {
        printf("%s %.3f\n", entries[i].key, (100.0 * entries[i].value) / total);
    }

    free(entries);
    free(kmer);
    free_table(table);
}

void generate_Count_For_Sequence(char *seq, size_t len, const char *query) {
    size_t k = strlen(query);
    int count = 0;
    for (size_t i = 0; i <= len - k; i++) {
        if (memcmp(&seq[i], query, k) == 0) {
            count++;
        }
    }
    printf("%d\t%s\n", count, query);
}

// 🔧 Main program
int main() {
    size_t len;
    char *sequence = read_input_fasta_sequence_THREE(&len);

    #pragma omp parallel sections
    {
        #pragma omp section
        {
            generate_Frequencies_For_Sequences(sequence, len, 1);
            printf("\n");
        }
        #pragma omp section
        {
            generate_Frequencies_For_Sequences(sequence, len, 2);
            printf("\n");
        }
        #pragma omp section
        {
            generate_Count_For_Sequence(sequence, len, "GGT");
        }
        #pragma omp section
        {
            generate_Count_For_Sequence(sequence, len, "GGTA");
        }
        #pragma omp section
        {
            generate_Count_For_Sequence(sequence, len, "GGTATT");
        }
        #pragma omp section
        {
            generate_Count_For_Sequence(sequence, len, "GGTATTTTAATT");
        }
        #pragma omp section
        {
            generate_Count_For_Sequence(sequence, len, "GGTATTTTAATTTATAGT");
        }
    }

    free(sequence);
    return 0;
}
