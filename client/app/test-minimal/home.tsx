import { View, Text, TouchableOpacity } from "react-native";
import { router } from "expo-router";

export default function HomeScreen() {
    return (
        <View className="flex-1 justify-center items-center bg-white px-6">
            <Text className="text-2xl font-bold mb-8">企業碳排管理</Text>
            <TouchableOpacity className="bg-green-700 rounded-xl py-3 w-full mb-4" onPress={() => router.push("/test-minimal/form")}>
                <Text className="text-white text-center font-bold text-base">填報碳排</Text>
            </TouchableOpacity>
            <TouchableOpacity className="bg-green-500 rounded-xl py-3 w-full mb-4" onPress={() => router.push("/test-minimal/data")}>
                <Text className="text-white text-center font-bold text-base">查詢資料</Text>
            </TouchableOpacity>
            <TouchableOpacity className="bg-gray-700 rounded-xl py-3 w-full mb-4" onPress={() => router.push("/test-minimal/settings")}>
                <Text className="text-white text-center font-bold text-base">設定</Text>
            </TouchableOpacity>
            <TouchableOpacity className="bg-red-600 rounded-xl py-3 w-full" onPress={() => router.replace("/test-minimal")}>
                <Text className="text-white text-center font-bold text-base">登出</Text>
            </TouchableOpacity>
        </View>
    );
}
