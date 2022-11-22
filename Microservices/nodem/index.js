const ydb = require('nodem').Ydb();
ydb.open({ipAddress: 'nodevista', tcpPort: 6789});
ydb.set('^RAM', 1, 'This is a test')
var resp=ydb.get({global: 'RAM', subscripts: [1]})
console.log(resp)
