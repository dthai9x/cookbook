import pandas as pd

def analyze_sales_data(csv_file_path):
    """
    Analyzes sales data from a CSV file.

    Args:
        csv_file_path (str): The path to the CSV file containing sales data.

    Returns:
        None. Prints the analysis results to the console.
    """
    try:
        df = pd.read_csv(csv_file_path)
        # Calculate total revenue
        df['total_price'] = df['quantity'] * df['price']
        total_revenue = df['total_price'].sum()

        # Calculate average order value
        average_order_value = df.groupby('order_id')['total_price'].sum().mean()

        print("Sales Data Analysis:")
        print(f"  Total Revenue: ${total_revenue:.2f}")
        print(f"  Average Order Value: ${average_order_value:.2f}")

    except FileNotFoundError:
        print(f"Error: File not found at {csv_file_path}")

if __name__ == "__main__":
    # Replace with the actual path to your CSV file
    sample_csv_path = "examples/sales_analysis/sales_data.csv"
    analyze_sales_data(sample_csv_path)
