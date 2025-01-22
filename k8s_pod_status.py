from kubernetes import client, config
import os

# Load the kubeconfig
try:
    config.load_kube_config()
    print("Kubernetes configuration loaded.")
except Exception as e:
    print(f"Error loading Kubernetes config: {e}")
    exit(1)

# Function to fetch logs and save them to a file
def save_pod_logs(pod_name, namespace='default'):
    try:
        logs = v1.read_namespaced_pod_log(name=pod_name, namespace=namespace)
        file_name = f"{pod_name}-logs.txt"
        with open(file_name, 'w') as f:
            f.write(logs)
        print(f"Logs saved to {file_name}")
    except Exception as e:
        print(f"Error fetching logs for pod {pod_name}: {e}")

# Create a Kubernetes client
v1 = client.CoreV1Api()

# List all pods in the default namespace
pods = v1.list_namespaced_pod(namespace='default')

# Check the status of each pod
for pod in pods.items:
    pod_name = pod.metadata.name
    pod_status = pod.status.phase
    print(f"Pod Name: {pod_name}, Status: {pod_status}")
    
    # Check for non-running pod status
    if pod_status != "Running":
        save_pod_logs(pod_name)
    else:
        # Check each container's status for CrashLoopBackOff or Error states
        for container in pod.status.container_statuses:
            container_name = container.name
            container_state = container.state
            if container_state.waiting and container_state.waiting.reason in ['CrashLoopBackOff', 'Error']:
                print(f"Container {container_name} in pod {pod_name} is in {container_state.waiting.reason} state.")
                save_pod_logs(pod_name)
