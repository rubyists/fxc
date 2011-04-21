function(doc){
  if(doc._id === "sofia.conf"){
    emit([doc.server, 0], 1);
  } else if(doc.name === "sofia.conf") {
    emit([doc.server, 1], 1);
  }
}
