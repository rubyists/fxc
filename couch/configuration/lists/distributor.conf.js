function(head, req){
  var row, doc;
  if(row = getRow()){ doc = row.value } else { return }

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <lists>
        {each(doc.lists, function(name, list){
          return(
            <list name={name} total-weight={list['total-weight']}>
              {each(list.nodes, function(i, node){
                return(
                  <node name={node.name} weight={node.weight} />
              )})}
            </list>
        )})}
      </lists>
    </configuration>
  </section>
</document>
  );
}
