{% set cfg = salt['mc_utils.json_load'](cfg)%}
{% set data = cfg.data %}
var countlyConfig = {
    /*  or for a replica set
    mongodb: {
        replSetServers : [
            '192.168.3.1:27017/?auto_reconnect=true',
            '192.168.3.2:27017/?auto_reconnect=true'
        ],
        db: "countly",
    },
    */
    /*  or define as a url
    mongodb: "localhost:27017/countly?auto_reconnect=true",
    */
    web: {
        port: {{data.front_port}},
        host: "localhost",
        use_intercom: true
    }
};

countlyConfig.mongodb = "{{data.mongo}}";
module.exports = countlyConfig;
