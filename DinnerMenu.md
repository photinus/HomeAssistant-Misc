
## Components

 - Node-Red
 - IFTTT
 - Google Sheets
 
## Google Sheets

This part is simple, just create a google sheet to track your menu for the week. 
The way I have it configured is to have 1 cell for each day of the week then a single cell that concatenates all the days of the week into one cell.

Sheet Formula
```
=ArrayFormula( CONCATENATE( D3:D7 & CHAR(10) ) )
```

## IFTTT

Create a google sheets monitor to watch the cell you put the formular into. 
Have this send a web request to your Node-Red flow (yes it has to be internet facing)

## Node-Red
Here is my snippit from Node-Red

```
[
    {
        "id": "9bf77661.e64c38",
        "type": "http in",
        "z": "2590d532.3c7f7a",
        "name": "",
        "url": "/webhooks",
        "method": "post",
        "upload": false,
        "swaggerDoc": "",
        "x": 280,
        "y": 280,
        "wires": [
            [
                "df2abcec.a0f63",
                "e445884c.6dfb58",
                "40aa7c1c.75ae04"
            ]
        ]
    },
    {
        "id": "df2abcec.a0f63",
        "type": "http response",
        "z": "2590d532.3c7f7a",
        "name": "",
        "statusCode": "200",
        "headers": {},
        "x": 1000,
        "y": 120,
        "wires": []
    },
    {
        "id": "9330ac77.ca373",
        "type": "api-call-service",
        "z": "2590d532.3c7f7a",
        "name": "",
        "server": "130115ac.9a475a",
        "service_domain": "input_text",
        "service": "set_value",
        "data": "",
        "mergecontext": "",
        "x": 750,
        "y": 280,
        "wires": [
            []
        ]
    },
    {
        "id": "40aa7c1c.75ae04",
        "type": "function",
        "z": "2590d532.3c7f7a",
        "name": "Data",
        "func": "msg.payload = {\n    \"data\": {\n        \"entity_id\":\"input_text.dinnermenu\",\n        \"value\": msg.payload\n    }\n}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 510,
        "y": 280,
        "wires": [
            [
                "9330ac77.ca373"
            ]
        ]
    }
]
```

## Home Assistant Markdown Card in Lovelace
```
- content: >
    <table><tr><td
    align='right'><b>Monday<br>Tuesday<br>Wednesday<br>Thursday<br>Friday<br>Saturday<br>Sunday</b></td><td>&nbsp;</td><td><pre
    style='margin-left: 10px; font-family: Roboto, Noto,
    sans-serif;'>[[ input_text.dinnermenu ]]</pre></td></tr></table>
  title: Dinner Menu
  type: markdown
```
