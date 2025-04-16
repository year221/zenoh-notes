import zenoh, time

def listener(sample):
    print(f"Received {sample.kind} ('{sample.key_expr}': '{sample.payload.to_string()}')")

if __name__ == "__main__":
    default_config = zenoh.Config()
    with zenoh.open(default_config) as session:
        sub = session.declare_subscriber('myhome/kitchen/temp', listener)
        time.sleep(60)