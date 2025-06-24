// DashboardScreen.tsx
import React, { useEffect, useState } from "react";
import { View, Text, ScrollView, Dimensions } from "react-native";
import { Pie, PolarChart } from "victory-native";

interface ChartItem {
    category: string;
    value: number;
}

function generateColorPalette(length: number): string[] {
    return Array.from({ length }, () =>
        `#${Math.floor(Math.random() * 0xffffff).toString(16).padStart(6, "0")}`
    );
}

export default function DashboardScreen() {
    const [data, setData] = useState<ChartItem[]>([]);
    const [totalValue, setTotalValue] = useState(0);
    const [monthlyAverage, setMonthlyAverage] = useState(0);
    const [colors, setColors] = useState<string[]>([]);

    useEffect(() => {
        const initialData = [
            { category: "電力排放量", value: 300 },
            { category: "員工糞肥管理", value: 200 },
            { category: "汽油燃燒排放量", value: 150 },
            { category: "柴油燃燒排放量", value: 120 },
            { category: "冷媒逸散排放量", value: 80 },
        ];
        const total = initialData.reduce((sum, d) => sum + d.value, 0);

        setColors(generateColorPalette(initialData.length));
        setData(initialData);
        setTotalValue(total);
        setMonthlyAverage(total / 12);
    }, []);

    const renderBar = (
        title: string,
        value: number,
        maxValue: number,
        color: string
    ) => (
        <View className="w-full mb-4" key={title}>
            <View className="flex-row justify-between mb-1">
                <Text className="text-gray-800 font-medium">{title}</Text>
                <Text className="text-gray-500">{value.toFixed(1)}</Text>
            </View>
            <View className="w-full h-2 bg-gray-200 rounded">
                <View
                    className="h-2 rounded"
                    style={{ width: `${(value / maxValue) * 100}%`, backgroundColor: color }}
                />
            </View>
        </View>
    );

    const pieData = data.map((item, index) => ({
        value: item.value,
        label: item.category,
        color: colors[index],
    }));

    return (
        <ScrollView className="flex-1 p-4 bg-white">
            {/* Summary */}
            <View className="mb-6">
                <Text className="text-lg font-medium text-black mb-2">
                    總碳排放分析
                </Text>
                <View className="flex-row justify-between">
                    <View className="w-1/2 p-2 border rounded mr-2">
                        <Text className="text-xs text-gray-500">Year total</Text>
                        <Text className="text-xl font-semibold text-black">
                            {Math.floor(totalValue)} tCO2
                        </Text>
                    </View>
                    <View className="w-1/2 p-2 border rounded ml-2">
                        <Text className="text-xs text-gray-500">Monthly average</Text>
                        <Text className="text-xl font-semibold text-black">
                            {Math.floor(monthlyAverage)} tCO2
                        </Text>
                    </View>
                </View>
            </View>

            {/* Progress bars */}
            <View className="mb-6 p-4 border rounded">
                {data.map((item, idx) =>
                    renderBar(item.category, item.value, totalValue, colors[idx])
                )}
            </View>

            {/* Pie Chart */}
            <View className="p-4 border rounded">
                <Text className="text-xl font-medium text-black mb-4">
                    年度總排放量
                </Text>
                <View className="h-[200px]">
                    <PolarChart
                        data={pieData}
                        colorKey="color"
                        valueKey="value"
                        labelKey="label"
                    >
                        <Pie.Chart innerRadius={50}>
                            {() => <Pie.Slice/>}
                        </Pie.Chart>
                    </PolarChart>
                </View>

                {/* Legend */}
                <View className="mt-4">
                    {pieData.map((item, index) => (
                        <View
                            key={index}
                            className="flex-row items-center space-x-2 mb-1"
                        >
                            <View
                                style={{ backgroundColor: item.color }}
                                className="w-3 h-3 rounded-sm"
                            />
                            <Text className="text-sm text-black">
                                {item.label}
                            </Text>
                        </View>
                    ))}
                </View>
            </View>
        </ScrollView>
    );
}
