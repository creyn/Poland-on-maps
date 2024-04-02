There is no easy way to download all your activities' KML files from the Garmin web portal.

I was able to find that script in the Garmin forum (https://forums.garmin.com/apps-software/mobile-apps-web/f/garmin-connect-web/166824/is-there-a-way-to-export-bulk-data-to-tcx-or-gpx-files-seems-like-i-can-only-bulk-export-to-csv-and-individual-activities-to-gpx#pifragment-1286=4).

In order to run in you have to login into Garmin portal, go to all activities, see how many you have and update the `limit` parameter in the script. Next you go into console (press F12) and copy-paste that script.

```javascript
	h={
	 'DI-Backend':'connectapi.garmin.com',
	 'Authorization':'Bearer '+JSON.parse(localStorage.token).access_token
	}

	fetch('https://connect.garmin.com/activitylist-service/activities/search/activities?limit=350',
	{'headers':h}).then((r)=>r.json()).then((all)=>{
	 t=0
	 all.forEach(async (a)=>{
	  await new Promise(s=>setTimeout(s,t+=5000))
	  fetch('https://connect.garmin.com/download-service/export/kml/activity/'+a.activityId,
	  {'headers':h}).then((r)=>r.blob()).then((b)=>{
	   console.dir(a.activityId)
	   f=document.createElement('a')
	   f.href=window.URL.createObjectURL(b)
	   f.download=a.activityId
	   f.click()
	  })
	 })
	})
```

