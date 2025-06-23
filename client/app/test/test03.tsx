// ElectricityScreen.tsx (React Native with Nativewind)
import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity } from 'react-native';
import { BarChart } from 'react-native-chart-kit'; // or victory-native
import AntDesign from '@expo/vector-icons/AntDesign';


interface ElectricityRow {
  month: string;
  consumption: number;
}

const sampleData: ElectricityRow[] = [
  { month: 'JAN', consumption: 200 },
  { month: 'FEB', consumption: 180 },
  // ...
];

export default function ElectricityScreen() {
  const [checked, setChecked] = useState<boolean[]>(
    Array(sampleData.length).fill(true)
  );

  const filteredData = sampleData.filter((_, i) => checked[i]);

  return (
    <ScrollView className="flex-1 bg-white p-4">
      <Text className="text-xl font-semibold mb-4">電力使用管理</Text>
      {sampleData.map((row, index) => (
        <TouchableOpacity
          key={row.month}
          className="flex-row items-center py-2 border-b border-gray-200"
          onPress={() =>
            setChecked((state) =>
              state.map((v, i) => (i === index ? !v : v))
            )
          }
        >
          <AntDesign
            name={checked[index] ? 'checkcircle' : 'checkcircleo'}
            size={20}
            color={checked[index] ? '#448fda' : '#ccc'}
            className="mr-2"
          />
          <Text className="flex-1">{row.month}</Text>
          <Text>{row.consumption} 度</Text>
        </TouchableOpacity>
      ))}

      <View className="mt-6">
        <BarChart
          data={{
            labels: filteredData.map((d) => d.month),
            datasets: [{ data: filteredData.map((d) => d.consumption) }],
          }}
          width={350}
          height={220}
          fromZero
          chartConfig={{
            backgroundColor: '#fff',
            backgroundGradientFrom: '#fff',
            backgroundGradientTo: '#fff',
            color: () => '#448fda',
          }}
        />
      </View>
    </ScrollView>
  );
}
