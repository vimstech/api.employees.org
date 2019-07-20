# *Employee Management*
_This application is to record employees details and their basic information along with their position in the organization._

## *Setup*
* fork repository to github handle
* clone the same from your github handle
* `bundle install` from project directroy
* run `rails db:create db:migrate` to setup database
* run `rails db:seed` to generate dummy data

## *Request* [Browser][GET only]
[all employees with pagination](http://localhost:3000/employees?only[]=name&only[]=salary&only[]=role&page=1&per=10)

[top ten employees (salary ratio)](http://localhost:3000/employees/top?only[]=name&only[]=salary&only[]=role)

[employee heirarcy (bottom to top)](http://localhost:3000/employees/150)

## *Requests* [CURL][Terminal]
  before running these you can run seed file from terminal
`rails db:seed` to generate dummy data.

### Create Employee

```
curl --location --request POST "http://localhost:3000/employees" \
  --header "Content-Type: application/json" \
  --data "{
	\"employee\": {
		\"name\": \"Mitesh Kothari\",
		\"email\": \"mitesh@gmail.com\",
		\"salary\": 15000000,
		\"mobile\": \"8685948596\",
		\"rating\": 4,
		\"role\": \"sde\"
	}
}"
```
### Output
```
{
    "id": 782,
    "name": "Mitesh Kothari",
    "email": "mitesh@gmail.com",
    "salary": 15000000,
    "mobile": "8685948596",
    "rating": 4,
    "role": "sde",
    "parent_id": null,
    "is_active": true,
    "created_at": "2019-07-20T17:30:48.678Z",
    "updated_at": "2019-07-20T17:30:48.678Z"
}
```

### Get employess
```
curl --location --request GET "http://localhost:3000/employees?page=1&per=10&only[]=name&only[]=role&only[]=salary"
```
### Output
```
[
    {
        "name": "ceo",
        "salary": 15000000,
        "role": "ceo"
    },
    {
        "name": "Kush Dhawan",
        "salary": 3461733,
        "role": "vp"
    },
    {
        "name": "Maria Bedi",
        "salary": 2564183,
        "role": "vp"
    },
    {
        "name": "Riya Acharya",
        "salary": 2346954,
        "role": "vp"
    },
    {
        "name": "Ananya Bajwa",
        "salary": 8059610,
        "role": "vp"
    },
    {
        "name": "John Bhasin",
        "salary": 7538173,
        "role": "vp"
    },
    {
        "name": "Aaradhya Reddy",
        "salary": 6659641,
        "role": "director"
    },
    {
        "name": "Mishti Bakshi",
        "salary": 6799406,
        "role": "director"
    },
    {
        "name": "Trisha Sharma",
        "salary": 4768803,
        "role": "director"
    },
    {
        "name": "Joshua Garg",
        "salary": 3524921,
        "role": "director"
    }
]
```

### Update Employee
```
curl --location --request PUT "http://localhost:3000/employees/782" \
  --header "Content-Type: application/json" \
  --data "{
	\"employee\": {
		\"salary\": 120000,
    \"parent_id\": 1
	}
}"
```
### Output
```
{
    "id": 782,
    "salary": 120000,
    "email": "mitesh@gmail.com",
    "parent_id": 1,
    "role": "sde",
    "name": "Mitesh Kothari",
    "mobile": "8685948596",
    "rating": 4,
    "is_active": true,
    "created_at": "2019-07-20T17:30:48.678Z",
    "updated_at": "2019-07-20T17:33:52.783Z"
}
```
### Get top ten employees (salary ratio)

```
curl --location --request GET "http://localhost:3000/employees/top?only[]=name&only[]=salary&only[]=role&"
```
### Output
```
[
    {
        "name": "ceo",
        "salary": 15000000,
        "role": "ceo"
    },
    {
        "name": "Vedant Khanna",
        "salary": 9988048,
        "role": "director"
    },
    {
        "name": "Reyansh Khurana",
        "salary": 9985664,
        "role": "sde"
    },
    {
        "name": "Sarah Arya",
        "salary": 9981360,
        "role": "sde"
    },
    {
        "name": "Luke Dayal",
        "salary": 9968702,
        "role": "sde"
    },
    {
        "name": "Riddhi Dalal",
        "salary": 9968485,
        "role": "sde"
    },
    {
        "name": "Mishti Lal",
        "salary": 9941600,
        "role": "sde"
    },
    {
        "name": "Ryan Bajwa",
        "salary": 9929691,
        "role": "sde"
    },
    {
        "name": "Prisha Apte",
        "salary": 9927079,
        "role": "sde"
    },
    {
        "name": "Divija Kohli",
        "salary": 9902418,
        "role": "manager"
    }
]
```

### Remove employee from org structure

```
curl --location --request POST "http://localhost:3000/employees/776/resign" \
  --header "Content-Type: application/json"
```
### Output
```
{
    "id": 776,
    "is_active": false,
    "parent_id": null,
    "email": "geneva@schroeder.info",
    "role": "sde",
    "name": "Saathvik Pandey",
    "salary": 7429855,
    "mobile": "666-831-2981",
    "rating": 4,
    "created_at": "2019-07-20T13:01:43.033Z",
    "updated_at": "2019-07-20T16:28:39.205Z"
}
```

### Show employee heirarchy (bottom to top)

```
curl --location --request GET "http://localhost:3000/employees/782" \
  --header "Content-Type: application/json" \
  --data ""
```
### Output
```
{
    "id": 782,
    "name": "Mitesh Kothari",
    "email": "mitesh@gmail.com",
    "salary": 120000,
    "mobile": "8685948596",
    "rating": 4,
    "role": "sde",
    "parent_id": 140,
    "is_active": true,
    "parent": {
        "id": 140,
        "name": "Vrinda Seth",
        "email": "ossie@goyettemarvin.name",
        "salary": 6405251,
        "mobile": "404-656-4128",
        "rating": 1,
        "role": "manager",
        "parent_id": 28,
        "is_active": true,
        "parent": {
            "id": 28,
            "name": "Saanvi Datta",
            "email": "cristie@torp.biz",
            "salary": 6306690,
            "mobile": "616-538-9536",
            "rating": 2,
            "role": "director",
            "parent_id": 6,
            "is_active": true,
            "parent": {
                "id": 6,
                "name": "John Bhasin",
                "email": "adell@prosaccocrist.info",
                "salary": 7538173,
                "mobile": "396-430-4359",
                "rating": 3,
                "role": "vp",
                "parent_id": 1,
                "is_active": true,
                "parent": {
                    "id": 1,
                    "name": "ceo",
                    "email": "ceo@employee.com",
                    "salary": 15000000,
                    "mobile": "8685948596",
                    "rating": 4,
                    "role": "ceo",
                    "parent_id": null,
                    "is_active": true,
                    "parent": {}
                }
            }
        }
    }
}
```