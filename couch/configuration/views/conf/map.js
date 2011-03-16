function(doc){
  if(/\.conf$/.test(doc.name)){
    emit([doc.name, doc.server], doc);
  }
}
