#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# This script simulates parsing a clinical data log and generating a report.
# In a real system, you'd be reading from a file or a database export.

my $clinical_data_log = q{
# Clinical Data Log for TRIAL-001
# Format: PATIENT_ID|FORM_NAME|VARIABLE_NAME|VALUE|UNIT|DATE
P001|Vital Signs|Systolic_BP|125.0|mmHg|2025-08-09
P002|Vital Signs|Systolic_BP|130.0|mmHg|2025-08-09
P001|Vital Signs|Diastolic_BP|80.0|mmHg|2025-08-09
P003|Vital Signs|Systolic_BP|118.0|mmHg|2025-08-09
P002|Lab Results|Glucose|95|mg/dL|2025-08-09
P003|Vital Signs|Diastolic_BP|75.0|mmHg|2025-08-09
};

my %patient_data;
my %variable_stats;

foreach my $line (split /\n/, $clinical_data_log) {
    next if $line =~ /^#/; # Skip comments
    
    my @fields = split /\|/, $line;
    next unless @fields == 6; # Ensure correct number of fields

    my ($patient_id, $form_name, $variable_name, $value, $unit, $date) = @fields;

    # Store data by patient
    push @{$patient_data{$patient_id}}, {
        form    => $form_name,
        var     => $variable_name,
        val     => $value,
        unit    => $unit,
        date    => $date
    };

    # Aggregate data for reporting (e.g., for statistical summary)
    if ($variable_name eq 'Systolic_BP') {
        push @{$variable_stats{$variable_name}}, $value;
    }
}

# --- Generate Report ---
print "--- Clinical Data Report for TRIAL-001 ---\n\n";

# Summary by Patient
print "1. Data Summary by Patient:\n";
foreach my $patient_id (sort keys %patient_data) {
    print "  Patient ID: $patient_id\n";
    foreach my $record (@{$patient_data{$patient_id}}) {
        print "    - $record->{form}, $record->{var}: $record->{val} $record->{unit}\n";
    }
    print "\n";
}

# Statistical Summary
print "2. Statistical Summary for Systolic BP:\n";
my @bp_values = @{$variable_stats{'Systolic_BP'}};
my $count = scalar @bp_values;
my $sum = 0;
foreach my $val (@bp_values) {
    $sum += $val;
}
my $average = $sum / $count;

print "  Total readings: $count\n";
print "  Average Systolic BP: $average mmHg\n";

print "\n--- Report End ---\n";
