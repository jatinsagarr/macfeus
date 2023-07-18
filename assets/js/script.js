const encode = (plainText) => {
    return CryptoJS.AES.encrypt(plainText, 'mac').toString();
}

const decode = (encryptText) => {
    return CryptoJS.AES.decrypt(encryptText, 'mac').toString(CryptoJS.enc.Utf8);
}

const parseURL = (href) => {
    var match = href.match(/^(https?\:)\/\/(([^:\/?#]*)(?:\:([0-9]+))?)([\/]{0,1}[^?#]*)(\?[^#]*|)(#.*|)$/);
    return match && {
        href: href,
        protocol: match[1],
        host: match[2],
        hostname: match[3],
        port: match[4],
        pathname: match[5],
        search: match[6],
        hash: match[7]
    }
}

class Communicate {
    static errorDialog = (msg) => {
        sendMessage("errordialog", JSON.stringify({ "message": encode(msg) }));
    }

    static showLoading = () => {
        sendMessage("loading", JSON.stringify({ "message": "none" }));
    }

    static closeLoading = () => {
        sendMessage("closeloading", JSON.stringify({ "message": "none" }));
    }

    static snackBar = (msg, type) => {
        sendMessage("snackbar", JSON.stringify({ "message": `${msg}`, "type": type }));
    }


}

class HttpsRequest {
    classObject = null;

    constructor(object) {
        this.classObject = object;
    }

    encodeHeaders = (_headers) => {
       let headers = {..._headers};
       try {
            for (const key in headers) {
                headers[key] = encode(headers[key]);
            }

            return encode(JSON.stringify(headers));
       } catch (error) {
           console.log(error);
       }
    }

    decodeResponse = (response) => {
        response = JSON.parse(decode(response));
        response.body = decode(response.body);

        let responseHeaders = JSON.parse(decode(response.headers));
        for (const key in responseHeaders) {
            let value = JSON.parse(decode(responseHeaders[key]));
            responseHeaders[key] = (value.length > 1) ? value : value[0];
        }
        response.headers = responseHeaders;
        response.statuscode = parseInt(decode(response.statuscode));
        response.statusmessage = parseInt(decode(response.statuscode));

        return response;
    }

    initGet = (requestLoad) => {
        sendMessage("get", JSON.stringify({
            "message": encode(JSON.stringify({
                "url": encode(requestLoad.url),
                "headers": this.encodeHeaders(requestLoad.headers),
                "payload": (requestLoad.hasOwnProperty("payload")) ? this.encodeHeaders(requestLoad.payload) : this.encodeHeaders({}),
                "classobject": encode(this.classObject),
                "callback": encode(requestLoad.callback),
                "timeout": (requestLoad.hasOwnProperty("timeout")) ? encode(`${requestLoad.timeout}`) : encode("1000")
            }))
        }));
    }
}



function communicate(channel, message) {
    sendMessage(channel, JSON.stringify({ "message": encode(message) }));
}

function message() {
    Communicate.snackBar("Hello Jatin Flutter Developer", 200);
}




class macScanner {
    https = new HttpsRequest("");

    headers = null; panel = null; mac = null; sub_part = null; portal = null;
    all_portal = [];

    constructor(classObject) {
        this.https = new HttpsRequest(classObject);
    }

    

    start = (portal, mac_a) => {
        try {
            this.panel = portal;
            this.portal = portal;
            this.mac = mac_a;

            let url = parseURL(this.panel);

            let sub_part;

            if (this.panel.includes("stalker_portal")) {
                this.panel = `${url.protocol}//${url.host}`; + "/stalker_portal";
                sub_part = "/server/load.php";
            } else {
                this.panel = url = `${url.protocol}//${url.host}`;
                sub_part = "/portal.php";
            }

            this.sub_part = sub_part;


            this.headers = {};

            this.headers["User-Agent"] = "Mozilla/5.0 (QtEmbedded; U; Linux; C; Windows NT 10.0; Win64; x64; rv:74.0) AppleWebKit/533.3 Gecko/20100101 Firefox/74.0 MAG200 stbapp ver: 2 rev: 250 Mobile Safari/533.3";
            this.headers["Referer"] = this.panel + "/c/";
            this.headers["Accept"] = "*/*";
            this.headers["Cookie"] = "mac=" + encodeURIComponent(this.mac) + "; stb_lang=en;";
            this.headers["Accept-Encoding"] = "gzip";
            this.headers["Connection"] = "Keep-Alive";
            this.headers["X-User-Agent"] = "Model: MAG250; Link: WiFi";
            this.headers["X-Requested-With"] = "XMLHttpRequest";

            this.https.initGet({
                url: this.panel + "/server/load.php?type=stb&action=handshake&JsHttpRequest=1-xml",
                headers: this.headers,
                callback: "token",
                timeout: 2000
            });
            
            return "200";
        } catch (error) {
            this.onError(`Start : ${error.message}`);
            return "400";
        }
    }

    token = (response) => {
        try {
            response = JSON.parse(this.https.decodeResponse(response).body);

            this.headers["Authorization"] = "Bearer " + response.js.token;
            let profile_url = this.panel + this.sub_part + `?type=stb&action=get_profile&hd=1&ver=${encodeURIComponent(`ImageDescription: 0.2.18-r14-pub-250; ImageDate: Fri Jan 15 15:20:44 EET 2016; PORTAL version: 5.3.0; API Version: JS API version: 328; STB API version: 134; Player Engine version: 0x566`)}&num_banks=2&sn=062014N012771&stb_type=MAG250&client_type=STB&image_version=218&video_out=hdmi&device_id=&device_id2=&signature=&auth_second_step=0&hw_version=1.7-BD-00&not_valid_token=0&metrics={"mac":"${this.mac}","sn":"062014N012771","model":"MAG250","type":"STB","uid":"","random":""}&hw_version_2=635dda7baba19b7057eedb54d10fe089e2e1f23d&timestamp=${Math.round(new Date().getTime() / 1000)}&api_signature=358&prehash=9c42ac937c6bc42ba21b45b853bfc020b013f8f6&JsHttpRequest=1-xml`;

            if (this.panel.includes("stalker_portal")) {
                profile_url = this.panel + this.sub_part + `?type=stb&action=get_profile&hd=1&ver=&num_banks=2&sn=undefined&stb_type=&client_type=STB&image_version=undefined&video_out=&device_id=&device_id2=&signature=&auth_second_step=0&hw_version=undefined&not_valid_token=1&metrics=${encodeURIComponent(JSON.stringify({ mac: this.mac, sn: "", model: "MAG250", type: "STB", uid: "", random: response.js.random }))}&hw_version_2=&timestamp=${Math.round(new Date().getTime() / 1000)}&api_signature=0&prehash=0&JsHttpRequest=1-xml`;
            }

            this.https.initGet({
                url: profile_url,
                headers: this.headers,
                callback: "getProfile",
                timeout: 2000
            });

            return "200";

        } catch (error) {
            this.onError(`Token : ${error.message}`);
            return "400";
        }

    }

    getProfile = (response) => {
        try {
            response = JSON.parse(this.https.decodeResponse(response).body);

            if (response.hasOwnProperty("js") && response.js.id) {
                this.https.initGet({
                    url: this.panel + this.sub_part + "?type=stb&action=get_localization&JsHttpRequest=1-xml",
                    headers: this.headers,
                    callback: "getLoc",
                    timeout: 2000
                });

                return "200";
            }

            throw { message: "STB MAC BLOCKED" };
        } catch (error) {
            this.onError(`Profile : ${error.message}`);
            return "400";
        }

    }

    getLoc = (response) => {
        try {
            response = JSON.parse(this.https.decodeResponse(response).body);

            if (response.hasOwnProperty("js")) {
                this.https.initGet({
                    url: this.panel + this.sub_part + "?type=account_info&action=get_main_info&JsHttpRequest=1-xml",
                    headers: this.headers,
                    callback: "getAccount",
                    timeout: 2000
                });

                return "200";
            }

            throw { message: "STB MAC BLOCKED" };
        } catch (error) {
             this.onError(`Profile : ${error.message}`);
             return "400";
        }

    }

    getAccount = (response) => {
        try {
            response = JSON.parse(this.https.decodeResponse(response).body);

            if (response.hasOwnProperty("js")) {
                if (this.panel.includes("stalker_portal")) {
                    if (!response.js.hasOwnProperty("end_date")) {
                        response.js.end_date = "Unlimited";
                    }
                }

                if (this.panel.includes("stalker_portal")) {
                    sendMessage("scandone", JSON.stringify({ "message": `${encode(JSON.stringify({ portal: this.portal, mac: this.mac, exp: response.js.end_date}))}`}));
                } else {
                    sendMessage("scandone", JSON.stringify({ "message": `${encode(JSON.stringify({ portal: this.portal, mac: this.mac, exp: response.js.phone}))}`}));
                }

                return "200";
            }

            throw { message: "STB MAC BLOCKED" };
        } catch (error) {
            this.onError(error.message);
            return "400";
        }

    }

    error = (err) => {
        try {
            sendMessage("scanerror", JSON.stringify({ "message": `${encode("NOT FOUND")}`}));
            return "200";
        } catch (error) {
            console.log(error.message);
            return "400";
        }
    }

    onError = (err) => {
         this.error(err);
    }


    setPortals = (response) => {
        try {
            response = decode(response);

            let url_regex = /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[a-zA-Z:0-9\/\._?=-]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[a-zA-Z:0-9\/\._?=-]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[a-zA-Z:0-9\/\._?=-]{2,}|www\.[a-zA-Z0-9]+\.[a-zA-Z:0-9\/]{2,}|[a-z]+\.[a-zA-Z:0-9\/\._?=-]{2,})/gi;
            let mac_regex = /[0-9A-Za-z]{2}:[0-9A-Za-z]{2}:[0-9A-Za-z]{2}:[0-9A-Za-z]{2}:[0-9A-Za-z]{2}:[0-9A-Za-z]{2}/gi;
            
            let urls = response.match(url_regex);
            let macs = response.match(mac_regex);

            if (urls == null || macs == null) {
                Communicate.closeLoading();
                Communicate.errorDialog("Please Enter Valid Required Feilds");
                return 400;
            }

            let url = parseURL(urls[0]);

            if (urls[0].includes("stalker_portal")) {
                url = `${url.protocol}//${url.host}/stalker_portal/c/`;
            } else {
                url = `${url.protocol}//${url.host}/c/`;
            }

            macs.map((item) => {
                this.all_portal.push({ portal: urls[0], mac: item });
            });

            macs.reverse();
            
            setTimeout(()=> this.all_portal = [],500);

            return JSON.stringify(this.all_portal);
        } catch (error) {
            this.onError(`${error.message}`);
            return "400";
        }

    }

}

const scanner = new macScanner("scanner");

