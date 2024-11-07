//generates rooms that will be traveled through for labs

#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
using namespace std;

class disjoint {
public:
    disjoint(int n) : parent(n), rank(n, 0) {
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
        }
    }
    
    //path compression
    int find(int u) {
        if (u != parent[u]) {
            parent[u] = find(parent[u]);
        }
        return parent[u];
    }

    //union by rank
    void unite(int u, int v) {
        int rootU = find(u);
        int rootV = find(v);
        if (rootU != rootV) {
            if (rank[rootU] > rank[rootV]) {
                parent[rootV] = rootU;
            } else if (rank[rootU] < rank[rootV]) {
                parent[rootU] = rootV;
            } else {
                parent[rootV] = rootU;
                rank[rootU]++;
            }
        }
    }

    bool connected(int u, int v) {
        return find(u) == find(v);
    }

private:
    vector<int> parent;
    vector<int> rank;
};

class roomGenerator {
public:
    roomGenerator(int min, int max) {
        srand(time(0));
        rooms = rand() % (max - min + 1) + min;
        generate();
    }

//prints rooms plus neighbors for testing purposes
    void display() {
        cout << "Generated " << rooms << endl;
        for (int i = 0; i < rooms; ++i) {
            cout << "neighbors: ";
            for (int j = 0; j < connections[i].size(); ++j) {
                cout << connections[i][j] << " ";
            }
            cout << endl;
        }
    }

private:
    int rooms;
    vector<vector<int>> connections;

    void generate() {
        disjoint ds(rooms);
        connections.resize(rooms);

        //makes sure all rooms are connected to each other
        while (!allRoomsConnected(ds)) {
            int room1 = rand() % rooms;
            int room2 = rand() % rooms;
            if (!ds.connected(room1, room2)) {
                ds.unite(room1, room2);
                connections[room1].push_back(room2);
                connections[room2].push_back(room1);
            }
        }

        int extras = rand() % (rooms / 2) + 1;
        for (int i = 0; i < extras; ++i) {
            int room1 = rand() % rooms;
            int room2 = rand() % rooms;
            if (room1 != room2 && !ds.connected(room1, room2)) {
                connections[room1].push_back(room2);
                connections[room2].push_back(room1);
            }
        }
    }

    bool allRoomsConnected(disjoint& ds) {
        int root = ds.find(0);
        for (int i = 1; i < rooms; ++i) {
            if (ds.find(i) != root) {
                return false;
            }
        }
        return true;
    }
};

int main() {
    roomGenerator generator(10, 15); //decided 10-15 rooms was a reasonable number
    generator.display();
    return 0;
}

