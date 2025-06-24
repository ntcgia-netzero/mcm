// dashboard/DashboardPage.tsx
import React from 'react';
import { View, Text, Dimensions, ScrollView } from 'react-native';
import { BarChart } from 'react-native-chart-kit';

// Sample data
const chartData = [
    { label: 'Electricity', value: 120 },
    { label: 'Employees', value: 50 },
    { label: 'Gasoline', value: 90 },
    { label: 'Diesel', value: 60 },
    { label: 'Refrigerant', value: 30 },
];

export default function DashboardPage() {
    const total = chartData.reduce((sum, item) => sum + item.value, 0);
    const monthlyAverage = total / 12;

    return (
        <ScrollView className="flex-1 bg-white p-4">
            <Text className="text-xl font-semibold text-gray-800 mb-4">
                Total Carbon Emissions
            </Text>

            <View className="flex-row justify-between p-4 bg-gray-100 rounded-md mb-6">
                <View>
                    <Text className="text-gray-500">Year total</Text>
                    <Text className="text-lg font-semibold">
                        {total.toFixed(0)} tCO₂
                    </Text>
                </View>
                <View>
                    <Text className="text-gray-500">Monthly average</Text>
                    <Text className="text-lg font-semibold">
                        {monthlyAverage.toFixed(1)} tCO₂
                    </Text>
                </View>
            </View>

            {/* Bar Chart */}
            <View className="mb-8">
                <BarChart
                    data={{
                        labels: chartData.map(c => c.label),
                        datasets: [{ data: chartData.map(c => c.value) }],
                    }}
                    width={Dimensions.get('window').width - 32}
                    height={220}
                    fromZero
                    chartConfig={{
                        backgroundColor: '#ffffff',
                        backgroundGradientFrom: '#ffffff',
                        backgroundGradientTo: '#ffffff',
                        decimalPlaces: 0,
                        barPercentage: 0.6,
                        color: () => '#448fda',
                        labelColor: () => '#475569',
                    }}
                    style={{ borderRadius: 8 }}
                />
            </View>

            {/* Simple table */}
            <View className="bg-gray-50 rounded-md">
                {chartData.map(item => (
                    <View
                        key={item.label}
                        className="flex-row justify-between py-3 px-4 border-b border-gray-200"
                    >
                        <Text className="text-gray-700">{item.label}</Text>
                        <Text className="text-gray-700">{item.value} tCO₂</Text>
                    </View>
                ))}
            </View>
        </ScrollView>
    );
}
