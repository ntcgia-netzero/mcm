import { View, Text, SafeAreaView, ScrollView, ActivityIndicator, Pressable } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { router } from "expo-router";

// 模擬範例資料
const mockData = [
    {
        id: "1",
        date: "2025-06-30",
        electricity: 1500,
        fuel: 200,
        refrigerant: 10,
        transportation: 50,
    },
    {
        id: "2",
        date: "2025-06-15",
        electricity: 1200,
        fuel: 180,
        refrigerant: 5,
        transportation: 40,
    },
];

export default function DataScreen() {
    const insets = useSafeAreaInsets();
    const isLoading = false; // 你可依實際 API 狀態切換

    return (
        <SafeAreaView
            className="flex-1 bg-white"
            style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}
        >
            <ScrollView
                className="flex-1 px-6"
                contentContainerStyle={{ paddingVertical: 40 }}
            >
                {/* 頁面標題 */}
                <Text className="text-3xl font-bold mb-8 text-black text-center">
                    碳排資料清單
                </Text>

                {isLoading && (
                    <ActivityIndicator size="large" color="black" className="my-10" />
                )}

                {!isLoading && mockData.length === 0 && (
                    <Text className="text-center text-gray-500">目前尚無填報資料</Text>
                )}

                {!isLoading &&
                    mockData.map((item) => (
                        <View
                            key={item.id}
                            className="bg-white rounded-2xl shadow-xl mb-6 p-5 w-full max-w-[400px] mx-auto"
                        >
                            <Text className="text-base font-semibold text-black mb-2">
                                填報日期：{item.date}
                            </Text>

                            <View className="mb-2">
                                <Text className="text-sm text-gray-700">
                                    用電量: <Text className="font-semibold">{item.electricity} kWh</Text>
                                </Text>
                            </View>

                            <View className="mb-2">
                                <Text className="text-sm text-gray-700">
                                    燃料用量: <Text className="font-semibold">{item.fuel} L</Text>
                                </Text>
                            </View>

                            <View className="mb-2">
                                <Text className="text-sm text-gray-700">
                                    冷媒使用量: <Text className="font-semibold">{item.refrigerant} kg</Text>
                                </Text>
                            </View>

                            <View>
                                <Text className="text-sm text-gray-700">
                                    員工交通排放: <Text className="font-semibold">{item.transportation} kg CO₂</Text>
                                </Text>
                            </View>

                            {/* 分隔線 */}
                            <View className="border-t border-gray-200 my-4" />

                            <Pressable
                                onPress={() => router.push(`/emission/${item.id}`)}
                                className="py-2 px-4 rounded-lg bg-black"
                            >
                                <Text className="text-white text-center text-sm font-semibold">
                                    查看詳細
                                </Text>
                            </Pressable>
                        </View>
                    ))}
            </ScrollView>
        </SafeAreaView>
    );
}
