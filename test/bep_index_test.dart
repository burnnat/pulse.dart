part of syncthing.bep_test;

void runIndexTests() {
  // Message length
  List<int> body = [
    0x00, 0x00, 0x00, 0xB0,
  ];

  body.addAll([
    // Length of folder name
    0x00, 0x00, 0x00, 0x07,
    // Folder name ("default")
    0x64, 0x65, 0x66, 0x61,
    0x75, 0x6C, 0x74, 0x00,
  ]);

  // Files
  body.addAll([
    // Files length header
    0x00, 0x00, 0x00, 0x02,

    // File #1
    // Name length header
    0x00, 0x00, 0x00, 0x05,
    // Name ("empty")
    0x65, 0x6D, 0x70, 0x74,
    0x79, 0x00, 0x00, 0x00,
    // Flags
    0x00, 0x00, 0x31, 0xFF,
    // Modified
    0x00, 0x00, 0x00, 0x00,
    0x54, 0xD6, 0x89, 0xDF,
    // Version
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x0A,
    // Local version
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x02,
    // Blocks length header
    0x00, 0x00, 0x00, 0x00,

    // File #2
    // Name length header
    0x00, 0x00, 0x00, 0x0C,
    // Name ("sub/file.txt")
    0x73, 0x75, 0x62, 0x2F,
    0x66, 0x69, 0x6C, 0x65,
    0x2E, 0x74, 0x78, 0x74,
    // Flags
    0x00, 0x01, 0x81, 0xB6,
    // Modified
    0x00, 0x00, 0x00, 0x00,
    0x26, 0x2F, 0xDF, 0x11,
    // Version
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x15,
    // Local version
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x0C,

    // Blocks length header
    0x00, 0x00, 0x00, 0x03,

    // Block #1
    // Size
    0x00, 0x02, 0x00, 0x00,
    // Hash length header
    0x00, 0x00, 0x00, 0x20,
    // Hash
    0x8D, 0x75, 0x8B, 0x34,
    0xE2, 0x36, 0x85, 0xE3,
    0x13, 0xC0, 0xBF, 0x81,
    0x94, 0x78, 0xBB, 0xCE,
    0xD2, 0x07, 0xE7, 0x04,
    0x38, 0x03, 0x89, 0xE9,
    0x1F, 0x4A, 0x36, 0xDA,
    0x61, 0x03, 0x93, 0x67,

    // Block #2
    // Size
    0x00, 0x02, 0x00, 0x00,
    // Hash length header
    0x00, 0x00, 0x00, 0x08,
    // Hash
    0x10, 0x5C, 0xE1, 0x0D,
    0xA9, 0x2C, 0xEF, 0xC1,

    // Block #3
    // Size
    0x00, 0x00, 0x0A, 0x09,
    // Hash length header
    0x00, 0x00, 0x00, 0x04,
    // Hash
    0xAD, 0x75, 0x94, 0x70,
  ]);

  XdrString folderName = new XdrString('default');
  List<FileInfo> files = [
    new FileInfo(
      new XdrString('empty'),
      new FileFlags(
        permissions: 0x1FF, // Octal 777
        deleted: true,
        invalid: true
      ),
      new Hyper(new Int(0), new Int(0x54D689DF)),
      new Hyper(new Int(0), new Int(0x0A)),
      new Hyper(new Int(0), new Int(0x02)),
      []
    ),
    new FileInfo(
      new XdrString('sub/file.txt'),
      new FileFlags(
        symbolicLink: true,
        undefinedTarget: true
      ),
      new Hyper(new Int(0), new Int(0x262FDF11)),
      new Hyper(new Int(0), new Int(0x15)),
      new Hyper(new Int(0), new Int(0x0C)),
      [
        new BlockInfo(
          new Int(0x20000),
          new Opaque([
            0x8D, 0x75, 0x8B, 0x34,
            0xE2, 0x36, 0x85, 0xE3,
            0x13, 0xC0, 0xBF, 0x81,
            0x94, 0x78, 0xBB, 0xCE,
            0xD2, 0x07, 0xE7, 0x04,
            0x38, 0x03, 0x89, 0xE9,
            0x1F, 0x4A, 0x36, 0xDA,
            0x61, 0x03, 0x93, 0x67,
          ])
        ),
        new BlockInfo(
          new Int(0x20000),
          new Opaque([
            0x10, 0x5C, 0xE1, 0x0D,
            0xA9, 0x2C, 0xEF, 0xC1,
          ])
        ),
        new BlockInfo(
          new Int(0x00A09),
          new Opaque([
            0xAD, 0x75, 0x94, 0x70,
          ])
        )
      ]
    )
  ];

  void checkPayload(AbstractIndex index) {
    expect(index.folder.value, equals('default'));

    List<FileInfo> files = index.files;
    expect(files.length, equals(2));

    FileInfo file;
    List<BlockInfo> blocks;

    file = files[0];
    blocks = file.blocks;
    expect(file.name.value, equals('empty'));
    expect(file.flags.undefinedTarget, isFalse);
    expect(file.flags.symbolicLink, isFalse);
    expect(file.flags.permissionsMissing, isFalse);
    expect(file.flags.invalid, isTrue);
    expect(file.flags.deleted, isTrue);
    expect(file.flags.permissions, 0x1FF);
    expect(file.modified.upper.value, equals(0));
    expect(file.modified.lower.value, equals(0x54D689DF));
    expect(file.version.upper.value, equals(0));
    expect(file.version.lower.value, equals(0x0A));
    expect(file.localVersion.upper.value, equals(0));
    expect(file.localVersion.lower.value, equals(0x02));
    expect(blocks, isEmpty);

    file = files[1];
    blocks = file.blocks;
    expect(file.name.value, equals('sub/file.txt'));
    expect(file.flags.undefinedTarget, isTrue);
    expect(file.flags.symbolicLink, isTrue);
    expect(file.flags.permissionsMissing, isFalse);
    expect(file.flags.invalid, isFalse);
    expect(file.flags.deleted, isFalse);
    expect(file.flags.permissions, 0x1B6);
    expect(file.modified.upper.value, equals(0));
    expect(file.modified.lower.value, equals(0x262FDF11));
    expect(file.version.upper.value, equals(0));
    expect(file.version.lower.value, equals(0x15));
    expect(file.localVersion.upper.value, equals(0));
    expect(file.localVersion.lower.value, equals(0x0C));
    expect(blocks.length, equals(3));

    BlockInfo block;

    block = blocks[0];
    expect(block.size.value, equals(0x20000));
    expect(
      block.hash.data,
      equals([
        0x8D, 0x75, 0x8B, 0x34,
        0xE2, 0x36, 0x85, 0xE3,
        0x13, 0xC0, 0xBF, 0x81,
        0x94, 0x78, 0xBB, 0xCE,
        0xD2, 0x07, 0xE7, 0x04,
        0x38, 0x03, 0x89, 0xE9,
        0x1F, 0x4A, 0x36, 0xDA,
        0x61, 0x03, 0x93, 0x67,
      ])
    );

    block = blocks[1];
    expect(block.size.value, equals(0x20000));
    expect(
      block.hash.data,
      equals([
        0x10, 0x5C, 0xE1, 0x0D,
        0xA9, 0x2C, 0xEF, 0xC1,
      ])
    );

    block = blocks[2];
    expect(block.size.value, equals(0x00A09));
    expect(
      block.hash.data,
      equals([
        0xAD, 0x75, 0x94, 0x70,
      ])
    );
  }

  group('Index message', () {
    List<int> serialized = new List.from([0x08, 0xC2, 0x01, 0x00]);
    serialized.addAll(body);

    // Make sure messages can be parsed from immutable lists.
    serialized = new List.from(serialized, growable: false);

    test('can serialize to buffer', () {
      BlockMessage message = new BlockMessage(0x8C2, new Index(folderName, files));
      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      BlockMessage message = new BlockMessage.fromBytes(serialized);
      BlockPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<Index>());
      checkPayload(payload as Index);
    });
  });

  group('Index update message', () {
    List<int> serialized = new List.from([0x08, 0xC2, 0x06, 0x00]);
    serialized.addAll(body);

    // Make sure messages can be parsed from immutable lists.
    serialized = new List.from(serialized, growable: false);

    test('can serialize to buffer', () {
      BlockMessage message = new BlockMessage(0x8C2, new IndexUpdate(folderName, files));
      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      BlockMessage message = new BlockMessage.fromBytes(serialized);
      BlockPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<IndexUpdate>());
      checkPayload(payload as IndexUpdate);
    });
  });
}
