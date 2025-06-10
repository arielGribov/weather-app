from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests
import urllib.parse


app = FastAPI()

app.add_middleware(
    CORSMiddleware, 
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
def geocode_city(city: str):
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
        return {"error": str(e)}
