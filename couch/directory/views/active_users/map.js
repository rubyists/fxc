function(doc){
  if(doc.type === 'user' && doc.active === true){
    emit([doc.id, doc.server], 1)
  }
}
