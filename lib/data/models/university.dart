class University {
   String? id;
   String? title;
   String? type;

   String? imageAssets;

   University({
     this.id,
     this.title,
     this.type,
     this.imageAssets,
  });
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'imageAssets': imageAssets,
    };
  }
  factory University.map({required Map<String,dynamic> map})
  {
    return University(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      imageAssets: map['imageAssets'],
    );
  }
}
