function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <profiles>{
        each(doc.profiles, function(name, obj){
          return <profile name={name}>
            <settings>{
              each(obj.settings, function(name, value){
                return <param name={name} value={value} />
              })
            }</settings>
            <soft-key-set-sets>{
              each(obj['soft-key-set-sets'], function(name, obj){
                return <soft-key-set-set>{
                  each(obj, function(name, value){
                    return <soft-key-set name={name} value={value} />
                  })
                }</soft-key-set-set>
              })
            }</soft-key-set-sets>
            <device-types>{
              each(obj['device-types'], function(id, obj){
                return <device-type id={id}>{
                  each(obj, function(name, value){
                    return <param name={name} value={value} />
                  })
                }</device-type>
              })
            }</device-types>
          </profile>
        })
      }</profiles>
    </configuration>
  </section>
</document>
  );
}
