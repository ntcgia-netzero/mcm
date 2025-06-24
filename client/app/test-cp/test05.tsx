// src/screens/RefrigerantPage.tsx
import React, { useState } from 'react';
import { View, Text, ScrollView, Dimensions } from 'react-native';
import { BarChart } from 'react-native-chart-kit';

/** Sample local data (remove network calls) */
const initialRows = [
    ['設備名稱', '冷媒型號', '冷媒補充量', '使用月數'],
    ['冷凍庫A', 'R32', '5 kg', '12 月'],
    ['冷凍庫B', 'R410A', '3 kg', ' 9 月'],
];

export default function RefrigerantPage() {
    const [rows] = useState(initialRows);
    const [checks, setChecks] = useState(Array(rows.length).fill(true));

    const toggle = (index: number) => {
        const updated = [...checks];
        updated[index] = !updated[index];
        setChecks(updated);
    };

    const barData = rows.slice(1).map(r => parseFloat(r[2]));

    return (
        <ScrollView className="flex-1 p-4 bg-gray-100">
            <Text className="text-lg font-semibold mb-4">冷媒設備管理表</Text>

            <View className="bg-white rounded-lg shadow">
                {rows.map((row, rIdx) => (
                    <View
                        key={rIdx}
                        className="flex-row items-center border-b border-gray-200"
                    >
                        {rIdx > 0 ? (
                            <View/>
                            // <CheckBox checked={checks[rIdx]} onPress={() => toggle(rIdx)} />
                        ) : (
                            <View className="w-8" />
                        )}
                        {row.map((cell, cIdx) => (
                            <Text
                                key={cIdx}
                                className="flex-1 p-2 text-sm"
                            >
                                {cell}
                            </Text>
                        ))}
                    </View>
                ))}
            </View>

            <Text className="text-lg font-semibold my-4">冷媒逸散排放量</Text>
            <BarChart
                data={{
                    labels: rows.slice(1).map(r => r[0]),
                    datasets: [{ data: barData }],
                }}
                width={Dimensions.get('window').width - 32}
                height={220}
                chartConfig={{
                    backgroundColor: '#ffffff',
                    backgroundGradientFrom: '#ffffff',
                    backgroundGradientTo: '#ffffff',
                    color: opacity => `rgba(68,143,218, ${opacity})`,
                    fillShadowGradient: '#448fda',
                    fillShadowGradientOpacity: 1,
                }}
                style={{ borderRadius: 8 }}
            />
        </ScrollView>
    );
}
