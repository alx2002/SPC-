net = require('net');
var clients = [];
const char = String.fromCharCode(0);

net.createServer(socket => {
   socket.setNoDelay(true);
   clients.push(socket);
   console.log("Connected.");
   
socket.on('data', data => {
   var x = data.readFloatBE(0);
   var y = data.readFloatBE(4);
   update(socket, x, y);
});

socket.on('error', error => {}
);

socket.on('close', () => {
   clients.splice(clients.indexOf(socket), 1);
   console.log("Closed.");
});

socket.on('end', () => {
    // ...
});

function update(sender, x, y) {
    for (var i = 0; i < clients.length; i++) {
        if (clients[i] !== sender) {
            clients[i].write(x + ":" + y + char);
        }
    }
}
}).listen(8888, '127.0.0.1');


console.log("Listening at: 8888")