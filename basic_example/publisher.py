import zenoh, random, time

random.seed()

def read_temp():
    return random.randint(15, 30)

if __name__ == "__main__":
    default_config = zenoh.Config()
    #default_config.insert("connect", '{endpoints: ["tcp/localhost:7447"]}')
    with zenoh.open(default_config) as session:    
    #with zenoh.open(zenoh.Config()) as session:
        key = 'myhome/kitchen/temp'
        pub = session.declare_publisher(key)
        while True:
            t = read_temp()
            buf = f"{t}"
            print(f"Putting Data ('{key}': '{buf}')...")
            pub.put(t)
            time.sleep(1)
