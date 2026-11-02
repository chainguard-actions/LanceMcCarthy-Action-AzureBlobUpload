// Usage: NODE_PATH=/tmp/azt/node_modules node list-blobs.js <container>
// Prints one blob name per line (sorted). Prints nothing if the container does not exist.
const {BlobServiceClient} = require('@azure/storage-blob');
const cs = process.env.AZ_CS;
const container = process.argv[2];
(async () => {
  const client = BlobServiceClient.fromConnectionString(cs).getContainerClient(container);
  if (!(await client.exists())) return;
  const names = [];
  for await (const b of client.listBlobsFlat()) names.push(b.name + '\t' + (b.properties.contentType || ''));
  names.sort();
  for (const n of names) console.log(n);
})().catch(e => {
  console.error(e);
  process.exit(1);
});
