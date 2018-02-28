-- Weatherunderground PWS upload script
-- (C)2018 Earthweb EWS, Based on GizMoCuz

-- Sensor Settings
Outside_Temp_Hum = ''
Barometer = ''
RainMeter = ''
WindMeter = ''
UVMeter = ''
Pressure = ''

--WU Settings
baseurl = "http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?"
ID = "STATION_ID"
PASSWORD = "STATION_PASSWORD"


local function CelciusToFarenheit(C)
   return (C * (9/5)) + 32
end 

local function hPatoInches(hPa)
   return hPa * 0.0295301
end

local function mmtoInches(mm)
   return mm * 0.039370
end


utc_dtime = os.date("!%m-%d-%y %H:%M:%S",os.time())

month = string.sub(utc_dtime, 1, 2)
day = string.sub(utc_dtime, 4, 5)
year = "20" .. string.sub(utc_dtime, 7, 8)
hour = string.sub(utc_dtime, 10, 11)
minutes = string.sub(utc_dtime, 13, 14)
seconds = string.sub(utc_dtime, 16, 17) 

timestring = year .. "-" .. month .. "-" .. day .. "+" .. hour .. "%3A" .. minutes .. "%3A" .. seconds

SoftwareType="Domoticz"

WU_URL= baseurl .. "ID=" .. ID .. "&PASSWORD=" .. PASSWORD .. "&dateutc=" .. timestring
--&winddir=230
--&windspeedmph=12
--&windgustmph=12

if Outside_Temp_Hum ~= '' then
   WU_URL = WU_URL .. "&tempf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_temperature[Outside_Temp_Hum]))
   WU_URL = WU_URL .. "&humidity=" .. otherdevices_humidity[Outside_Temp_Hum]
   WU_URL = WU_URL .. "&dewptf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_dewpoint[Outside_Temp_Hum]))
   Sensor = Outside_Temp_Hum
end

if Barometer ~= '' then
   WU_URL = WU_URL .. "&baromin=" .. string.format("%2.2f", hPatoInches(otherdevices_barometer[Barometer]))
   Sensor = Barometer
end

if Pressure ~= '' then
   WU_URL = WU_URL .. "&baromin=" .. string.format("%2.2f", hPatoInches(otherdevices_svalues[Pressure]))
   Sensor = Pressure
end

if RainMeter ~= '' then
   WU_URL = WU_URL .. "&dailyrainin=" .. string.format("%2.2f", mmtoInches(otherdevices_rain[RainMeter]))
   WU_URL = WU_URL .. "&rainin=" .. string.format("%2.2f", mmtoInches(otherdevices_rain_lasthour[RainMeter]))
   Sensor = RainMeter
end

if WindMeter ~= '' then
   WU_URL = WU_URL .. "&winddir=" .. string.format("%.0f", otherdevices_winddir[WindMeter])
   WU_URL = WU_URL .. "&windspeedmph=" .. string.format("%.0f", (otherdevices_windspeed[WindMeter]/0.1)*0.223693629205)
   WU_URL = WU_URL .. "&windgustmph=" .. string.format("%.0f", (otherdevices_windgust[WindMeter]/0.1)*0.223693629205)
   Sensor = WindMeter
end

if UVMeter ~= '' then
   WU_URL = WU_URL .. "&UV=" .. string.format("%.1f", mmtoInches(otherdevices_uv[UVMeter]))
   Sensor = UVMeter
end

--&weather=
--&clouds=

-- Current date as date.year, date.month, date.day, date.hour, date.min, date.sec
date = os.date("*t")
if (date.min % 5 == 0) then

    WU_URL = WU_URL .. "&softwaretype=" .. SoftwareType .. "&action=updateraw"

    print ('Uploading data to Weather Underground')
    --print (WU_URL)

    print ('ID=' .. ID)
    print ('Sensor=' .. Sensor)

    commandArray = {}

    --remove the line below to actualy upload it
    commandArray['OpenURL']=WU_URL

    print ('Uploading data to Weather Underground completed')
else
    
    commandArray = {}
end
