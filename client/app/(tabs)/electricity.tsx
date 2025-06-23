import { View, Text, Pressable, ScrollView } from "react-native";
import Checkbox from "expo-checkbox";
import { useState } from "react";
import { router } from "expo-router";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import { SafeAreaView } from "react-native";
const months = Array.from({ length: 12 }, (_, i) => `${i + 1} 月`);

export default function ElectricityPage() {
    const [values, setValues] = useState(Array(12).fill(""));
    const [included, setIncluded] = useState(Array(12).fill(true));

    const toggleIncluded = (index: number) => {
        const newIncluded = [...included];
        newIncluded[index] = !newIncluded[index];
        setIncluded(newIncluded);
    };

    const handleEdit = (index: number) => {
        router.push(`/edit/${index}`);
    };

    return (
        <SafeAreaView>
            <ScrollView className="p-4">
                <View className="border border-gray-300 rounded-lg overflow-hidden">
                    {/* Header */}
                    <View className="flex-row bg-gray-200">
                        <Text className="w-[10%] text-center py-2 font-bold">統計</Text>
                        <Text className="w-[30%] text-center py-2 font-bold">月份</Text>
                        <Text className="w-[60%] text-center py-2 font-bold">用電量 (kWh)</Text>
                    </View>

                    {/* Rows */}
                    {months.map((month, i) => (
                        <View
                            key={i}
                            className={`flex-row items-center border-t border-gray-300 ${i % 2 === 0 ? "bg-white" : "bg-gray-50"
                                }`}
                        >
                            {/* Checkbox */}
                            <View className="w-[10%] items-center">
                                <Checkbox
                                    value={included[i]}
                                    onValueChange={() => toggleIncluded(i)}
                                    color={included[i] ? "#2b7fff" : undefined}
                                    className="m-2"
                                />
                            </View>

                            {/* Month */}
                            <Text className="w-[30%] text-center py-3">{month}</Text>

                            {/* Value + Edit */}
                            <View className="w-[60%] flex-row items-center justify-center px-2 py-3">
                                <Text className="flex-1 text-center text-base">
                                    {values[i] || "尚未輸入"}
                                </Text>
                                <Pressable onPress={() => handleEdit(i)} className="p-2 rounded">
                                    <FontAwesome name="pencil" size={24} color="black" />
                                </Pressable>
                            </View>
                        </View>
                    ))}
                </View>
            </ScrollView>
        </SafeAreaView>
    );
}
