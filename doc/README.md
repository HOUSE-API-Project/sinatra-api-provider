## API Documents

Get parameters.
This API takes following parameters.

```
GET /api/:housename/:device/:keys
```

Parameters:

+ `housename` (required) - The name of the house.
+ `device` (required) - Devices (1f, 2f, wifi, etc...)
+ `keys` (required) - The key name (temperature, etc...)

```json
{
  "_id":
    {
      "$oid": "52d39c3fc3ca7c3eb9026067"
    },
  "temperature":"49",
  "time":"2014-01-13 07:56:39 UTC"
}

```

## Multi records

Use limit parameter.

```
GET /api/:housename/:device/:keys?limit=5
```

Parameters:

+ `limit` - Record limits. Specify integer.

```json
[
  {
    "_id":
      {
        "$oid": "52d39d69c3ca7c3eb90260a5"
      },
    "temperature":"49",
    "time":"2014-01-13 08:01:37 UTC"
  },
  {
    "_id":
      {
        "$oid": "52d39d26c3ca7c3eb9026092"
      },
    "temperature":"49",
    "time":"2014-01-13 08:00:36 UTC"
  },
  {
    "_id":
      {
        "$oid": "52d39cf0c3ca7c3eb902608c"
      },
    "temperature":"49",
    "time":"2014-01-13 07:59:37 UTC"
  }
]
```

## From and to

Need to limit parameter. If omitted, show one record within the period.

```
GET /api/:housename/:device/:keys?from=20140113080810&to=20140113080950&limit=5
```

Parameters:

+ `from` (optional) - From datetime. The format is YYYYMMDDhhmmss (UTC).
+ `to` (optional) - To datetime. Same above.

## Period

Period parameter takes certain period of time.

```
GET /api/:housename/:device/:keys?period=day&limit=5
```

Parameters:

+ `period` - The certain period of time. Specify 'day', 'week' or 'month'.

## Sort

Sort=asc means sort by ascending. It will sort decending order in other case.

```
GET /api/:housename/:device/:keys?limit=5&sort=asc
```

Parameters:

+ `sort` (optional) - If 'asc' specified, sort ascending.

