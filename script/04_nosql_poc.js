// 04_nosql_poc.js


use('omnichannel_nosql');

db.createCollection('logs_navegacao');

db.getCollection('logs_navegacao').insertMany([
  {
    cliente_id: 101,
    data_hora: new Date(),
    pagina_visitada: '/produto/smartphone-galaxy-s23',
    acao: 'visualizacao_produto',
    dispositivo: 'Mobile'
  },
  {
    cliente_id: 102,
    data_hora: new Date(),
    pagina_visitada: '/carrinho',
    acao: 'visualizacao_carrinho',
    dispositivo: 'Desktop'
  },
  {
    cliente_id: 103,
    data_hora: new Date(),
    pagina_visitada: '/busca?q=fone-bluetooth',
    acao: 'pesquisa',
    dispositivo: 'Tablet'
  }
]);

db.getCollection('logs_navegacao').find({}).sort({ data_hora: -1 });
