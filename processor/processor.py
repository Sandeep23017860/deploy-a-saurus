import time

def main():
    print("Processor service starting...")
    while True:
        print("Listening for messages to process...")
        time.sleep(10)

if __name__ == "__main__":
    main()```