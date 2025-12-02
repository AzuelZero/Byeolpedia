import requests
import json
import time

BASE_URL = "http://localhost:8000/api"

def test_registration():
    print("Testing Registration Endpoint...")
    
    # Generate a unique email to avoid conflicts
    timestamp = int(time.time())
    email = f"test_user_{timestamp}@example.com"
    username = f"user_{timestamp}"
    
    payload = {
        "username": username,
        "email": email,
        "collector_name": f"Collector {timestamp}",
        "password": "securepassword123",
        "password_confirm": "securepassword123"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/auth/register/", json=payload)
        
        print(f"Status Code: {response.status_code}")
        print(f"Response Body: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 201:
            print("✅ Registration Successful!")
            return True
        else:
            print("❌ Registration Failed.")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection Error: Is the backend server running on port 8000?")
        return False

if __name__ == "__main__":
    test_registration()
