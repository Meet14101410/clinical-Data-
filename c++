#include <iostream>
#include <vector>
#include <string>
#include <numeric> // For std::accumulate
#include <memory>  // For std::shared_ptr

// Represents a single clinical data point
struct CrfDataPoint {
    std::string patientId;
    std::string trialId;
    std::string formName;
    std::string variableName;
    double value;
};

// Function to calculate the average of a variable across a patient cohort
double calculate_average(const std::vector<std::shared_ptr<CrfDataPoint>>& data_points, const std::string& variable_name) {
    std::vector<double> values;
    for (const auto& dp : data_points) {
        if (dp->variableName == variable_name) {
            values.push_back(dp->value);
        }
    }
    
    if (values.empty()) {
        return 0.0;
    }
    
    double sum = std::accumulate(values.begin(), values.end(), 0.0);
    return sum / values.size();
}

int main() {
    // In a real application, this data would be loaded from a database or file.
    // We'll create a mock dataset here.
    std::vector<std::shared_ptr<CrfDataPoint>> mock_data;
    mock_data.push_back(std::make_shared<CrfDataPoint>("P001", "TRIAL-001", "Vital Signs", "Systolic_BP", 125.0));
    mock_data.push_back(std::make_shared<CrfDataPoint>("P002", "TRIAL-001", "Vital Signs", "Systolic_BP", 130.0));
    mock_data.push_back(std::make_shared<CrfDataPoint>("P003", "TRIAL-001", "Vital Signs", "Systolic_BP", 118.0));
    mock_data.push_back(std::make_shared<CrfDataPoint>("P001", "TRIAL-001", "Vital Signs", "Diastolic_BP", 80.0));
    mock_data.push_back(std::make_shared<CrfDataPoint>("P002", "TRIAL-001", "Vital Signs", "Diastolic_BP", 85.0));
    
    // Calculate the average systolic blood pressure
    double average_bp = calculate_average(mock_data, "Systolic_BP");
    
    std::cout << "Average Systolic Blood Pressure for TRIAL-001: " << average_bp << " mmHg" << std::endl;
    
    return 0;
}
