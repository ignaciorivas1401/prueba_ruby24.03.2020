require "url"
require "net/http"
require "json"

def build_web_page(response)
    cadena = ""
    response["photos"].each do |value|
        url = value["img_src"]
        cadena += "\t\t<li><img src=\"#{url}\"></li>\n"
    end
    cadena2 = 
        "<html>
            <head></head>
            <body>
        #{cadena}
            </body>
        </html>"
    File.write("resultado.html", cadena2)
end

def photos_count(response)
    hash = {}
    response["photos"].each do |value|
        if hash.key?(value["camera"]["full_name"])
            hash[value["camera"]["full_name"]] += 1
        else
            hash[value["camera"]["full_name"]] = 1
        end
    end
    return hash
end

def request(url, api_key)
    url = URI("#{url}#{api_key}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    response = JSON.parse(response.read_body)
end

url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key="
api_key = "Y5GEgRMBQoYyjKTEECZlbRV6ChUc4DPkI2t0DJ32"
response = request(url, api_key)
photos_count(response)
build_web_page(response)