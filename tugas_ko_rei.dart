import 'dart:io';
import 'dart:async';
import 'dart:math';

// Kelas baru untuk Node
class Node {
  String? data;
  Node? next;

  Node(this.data);
}

// Fungsi penundaan
Future<void> delay(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

// Fungsi untuk memindahkan kursor ke lokasi tertentu
void moveTo(int row, int col) {
  stdout.write('\x1B[${row};${col}H');
}

// Dapatkan ukuran layar terminal
getScreenSize() {
  return [stdout.terminalColumns, stdout.terminalLines];
}

// Membersihkan layar
void clearScreen() {
  stdout.write("\x1B[2J\x1B[H");
}

// Fungsi untuk memasukkan node baru di akhir, sekarang dengan cara yang berbeda
Node appendToEnd(Node head, String value) {
  Node currentNode = head;
  while (currentNode.next != null) {
    currentNode = currentNode.next!;
  }
  currentNode.next = Node(value);
  return head;
}

// Looping node menjadi sirkular tanpa fungsi activateLoop terpisah
void makeCircular(Node head) {
  Node currentNode = head;
  while (currentNode.next != null) {
    currentNode = currentNode.next!;
  }
  currentNode.next = head;
}

// Buat linked list dari input string
Node createLinkedList(String input) {
  Node head = Node(input[0]);
  for (int i = 1; i < input.length; i++) {
    appendToEnd(head, input[i]);
  }
  makeCircular(head);
  return head;
}

// Dapatkan warna secara acak
String getRandomColor() {
  final List<int> ansiColors =
      List.generate(6, (index) => 31 + index); // [31, 32, ..., 36]
  ansiColors
      .addAll([91, 92, 93, 94, 95, 96, 97, 30, 37, 90]); // Warna-warna tambahan

  Random rng = Random();
  return '\x1B[${ansiColors[rng.nextInt(ansiColors.length)]}m';
}

// Fungsi utama
void main() async {
  // Input dari pengguna
  stdout.write("Masukkan teks untuk animasi: ");
  String? input = stdin.readLineSync();

  if (input == null || input.isEmpty) {
    print("Input tidak valid. Keluar dari program.");
    return;
  }

  // Buat linked list dari input pengguna
  Node head = createLinkedList(input);
  clearScreen();

  Node? currentNode = head;
  List<int> screenSize = getScreenSize();

  for (int row = 1; row <= screenSize[1]; row++) {
    String color = getRandomColor(); // Dapatkan warna acak di setiap baris

    if (row.isOdd) {
      // Baris ganjil: cetak dari kiri ke kanan
      for (int col = 1; col <= screenSize[0]; col++) {
        moveTo(row, col);
        stdout.write(color +
            currentNode!.data! +
            '\x1B[0m'); // Reset warna setelah setiap output
        currentNode = currentNode.next;
        await delay(10);
      }
    } else {
      // Baris genap: cetak dari kanan ke kiri
      for (int col = screenSize[0]; col > 0; col--) {
        moveTo(row, col);
        stdout.write(color + currentNode!.data! + '\x1B[0m');
        currentNode = currentNode.next;
        await delay(10);
      }
    }
  }
}
