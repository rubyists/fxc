function(doc){
  if(doc.type === 'user'){
    emit([doc.id, doc.server], 1)
  }
}
