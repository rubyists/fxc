function(doc){
  if(doc._id === "sofia.conf"){
    emit([doc.server, 0], doc);
  } else if(doc.name === "sofia.conf") {
    emit([doc.server, 1], doc);
  }
}
