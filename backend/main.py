from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests

app = FastAPI()

app.add_middleware(
    CORSMiddleware, 
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def get_weather(city):
    try:
        WEATHER_API_URL = f"https://wttr.in/{city}?format=j1"

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
