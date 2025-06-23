// Example of a pie chart using Victory Native with React Native
// (Done)
import React from "react";
import { View, Text } from "react-native";
import { Pie, PolarChart } from "victory-native";

const randomNumber = () => Math.floor(Math.random() * (50 - 25 + 1)) + 125;
function generateRandomColor(): string {
    const randomColor = Math.floor(Math.random() * 0xffffff);
    return `#${randomColor.toString(16).padStart(6, "0")}`;
}

const data = [
    { value: 10, color: generateRandomColor(), label: "First" },
    { value: 20, color: generateRandomColor(), label: "Second" },
    { value: 30, color: generateRandomColor(), label: "Third" },
    { value: 25, color: generateRandomColor(), label: "Fourth" },
    { value: 15, color: generateRandomColor(), label: "Fifth" },
];

export default function PieChart() {
    return (
        <View className="flex-1 bg-white dark:bg-black px-5 py-8">
            <View className="h-4/5 bg-white dark:bg-black w-full">
                <PolarChart
                    data={data}
                    colorKey="color"
                    valueKey="value"
                    labelKey="label"
                >
                    <Pie.Chart>
                        {() => (
                            <>
                                <Pie.Slice />
                            </>
                        )}
                    </Pie.Chart>
                </PolarChart>
            </View>

            <View className="h-1/5 bg-white dark:bg-black w-full">
                {data.map((val, index) => (
                    <View
                        key={index}
                        className="flex-row items-center justify-center space-x-2 my-1"
                    >
                        <View
                            style={{ backgroundColor: val.color }}
                            className="w-2.5 h-2.5 rounded-sm"
                        />
                        <Text className="text-base w-20 text-black dark:text-white">
                            {val.label}
                        </Text>
                    </View>
                ))}
            </View>
        </View>
    );
};
