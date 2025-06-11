from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests
import urllib.parse


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=["https://yourfrontend.com"] lets change this to a specific domain - why? give me a reason please
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
def geocode_city(city: str):
    #You call requests.get() inside a helper (geocode_city) but invoke it from an async route.
    # This leads to the same blocking issue as above
    #
    #import httpx
    # async def geocode_city(city: str):
    # ...
    # async with httpx.AsyncClient() as client:
    #     response = await client.get(url, headers=headers

    url = f"https://nominatim.openstreetmap.org/search?q={urllib.parse.quote(city)}&format=json&limit=1"
    headers = {"User-Agent": "WeatherApp/1.0"}
    response = requests.get(url, headers=headers)
    data = response.json()

    if not data:
        raise Exception("Could not geocode city")

    lat = data[0]["lat"]
    lon = data[0]["lon"]
    return lat, lon

@app.get("/")
async def get_weather(city):
    try:
       # WEATHER_API_URL = f"https://wttr.in/{city}?format=j1"
        lat, lon = geocode_city(city)
        WEATHER_API_URL = f"https://wttr.in/~{lat},{lon}?format=j1"

        response = requests.get(WEATHER_API_URL)
        # lets change this to async compatibility
        # FastAPI is built for high performance via asynchronous I/O.
        # Using requests blocks the event loop, reducing throughput and scalability.
        # Under load, it will cause concurrency bottlenecks.
        #
        #import httpx
        # async with httpx.AsyncClient() as client:
        #   response = await client.get(WEATHER_API_URL)
        #   response.raise_for_status()
        #   data = response.json()

        data = response.json()

        current = data["current_condition"][0]
        return {
            "city": city,
            "temperature": current["temp_C"] + "°C",
            "description": current["weatherDesc"][0]["value"],
            "humidity": current["humidity"] + "%",
            "wind_speed": current["windspeedKmph"] + " km/h"
        }
    except Exception as e:
    #Improve Error Handling and Observability

    # import logging

    # logger = logging.getLogger("weather_app")
    # logging.basicConfig(level=logging.INFO)

    # except Exception as e:
    #     logger.exception("Error fetching weather data")
    #     return {"error": "Internal server error"}
        return {"error": str(e)}
