import { View, Text, FlatList } from "react-native";

type DataItem = {
    id: string;
    source: string;
    amount: number;
    date: string;
};

const DATA: DataItem[] = [
    { id: "1", source: "用電", amount: 100, date: "2024-06-01" },
    { id: "2", source: "燃料", amount: 50, date: "2024-06-02" },
];

export default function DataScreen() {
    return (
        <View className="flex-1 px-6 pt-12 bg-white">
            <Text className="text-2xl font-bold mb-8 text-center">碳排資料查詢</Text>
            <FlatList
                data={DATA}
                keyExtractor={item => item.id}
                renderItem={({ item }) => (
                    <View className="border-b border-gray-200 py-3">
                        <Text className="text-base">來源: {item.source}</Text>
                        <Text className="text-base">數量: {item.amount} 公斤</Text>
                        <Text className="text-base">日期: {item.date}</Text>
                    </View>
                )}
            />
        </View>
    );
}
