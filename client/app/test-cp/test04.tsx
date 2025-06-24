// app/screens/ElectricityPage.tsx 醜bar chart
import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity } from 'react-native';
import { BarChart } from 'react-native-chart-kit';
import { Dimensions } from 'react-native';

interface Row {
    month: string;
    consumption: number;
    checked: boolean;
}

const initialRows: Row[] = [
    { month: 'JAN', consumption: 0, checked: true },
    { month: 'FEB', consumption: 0, checked: true },
    { month: 'MAR', consumption: 0, checked: true },
    { month: 'APR', consumption: 0, checked: true },
    { month: 'MAY', consumption: 0, checked: true },
    { month: 'JUN', consumption: 0, checked: true },
    { month: 'JUL', consumption: 0, checked: true },
    { month: 'AUG', consumption: 0, checked: true },
    { month: 'SEP', consumption: 0, checked: true },
    { month: 'OCT', consumption: 0, checked: true },
    { month: 'NOV', consumption: 0, checked: true },
    { month: 'DEC', consumption: 0, checked: true },
];

export default function ElectricityPage() {
    const [rows, setRows] = useState<Row[]>(initialRows);

    const toggleRow = (index: number) => {
        const newRows = [...rows];
        newRows[index].checked = !newRows[index].checked;
        setRows(newRows);
    };

    const chartData = {
        labels: rows.filter(r => r.checked).map(r => r.month),
        datasets: [
            {
                data: rows.filter(r => r.checked).map(r => r.consumption),
                color: () => '#448fda',
            },
        ],
    };

    return (
        <ScrollView className="flex-1 bg-white">
            <View className="h-24 bg-blue-500 justify-center items-center">
                <Text className="text-lg font-semibold text-white">電力使用管理</Text>
            </View>

            {/* Data table */}
            <View className="px-4 py-6 space-y-3">
                {rows.map((row, index) => (
                    <TouchableOpacity
                        key={row.month}
                        onPress={() => toggleRow(index)}
                        className="flex-row justify-between items-center border-b border-gray-200 py-2"
                    >
                        <Text className="flex-1">{row.month}</Text>
                        <Text className="flex-1 text-right">{row.consumption} 度</Text>
                        <Text className="pl-2">{row.checked ? '☑' : '☐'}</Text>
                    </TouchableOpacity>
                ))}
            </View>

            {/* Bar chart */}
            <View className="px-4 py-6">
                <Text className="mb-2 font-medium">電力排放量</Text>
                <BarChart
                    data={chartData}
                    width={Dimensions.get('window').width - 32} // minus padding
                    height={220}
                    fromZero
                    yAxisSuffix="度"
                    chartConfig={{
                        backgroundColor: '#ffffff',
                        backgroundGradientFrom: '#ffffff',
                        backgroundGradientTo: '#ffffff',
                        decimalPlaces: 0,
                        color: () => '#448fda',
                        labelColor: () => '#6b7280',
                        barPercentage: 0.6,
                    }}
                    style={{ borderRadius: 8 }}
                />
            </View>
        </ScrollView>
    );
}
