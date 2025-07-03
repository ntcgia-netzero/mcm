import { Dimensions, View, Text, Pressable, ScrollView, TextInput } from "react-native";
import Checkbox from "expo-checkbox";
import { useState } from "react";
import { FontAwesome, Feather, MaterialIcons } from "@expo/vector-icons";
import { Palette } from "@/theme";
import Modal from 'react-native-modal';
import { BarChart } from 'react-native-chart-kit';


const months = Array.from({ length: 12 }, (_, i) => `${i + 1} 月`);


const rows = [
    { month: 0, consumption: 200, checked: true },
    { month: 1, consumption: 300, checked: true },
    { month: 2, consumption: 400, checked: true },
    { month: 3, consumption: 0, checked: true },
    { month: 4, consumption: 0, checked: true },
    { month: 5, consumption: 0, checked: true },
    { month: 6, consumption: 0, checked: true },
    { month: 7, consumption: 0, checked: true },
    { month: 8, consumption: 0, checked: true },
    { month: 9, consumption: 0, checked: true },
    { month: 10, consumption: 0, checked: true },
    { month: 11, consumption: 0, checked: true },
];
const chartConfig = {
    backgroundGradientFrom: '#fff',
    backgroundGradientTo: '#fff',

    /* --- 讓顏色變成實心 --- */
    fillShadowGradientFrom: Palette.primary,
    fillShadowGradientFromOpacity: 1,
    fillShadowGradientTo: Palette.primary,
    fillShadowGradientToOpacity: 1,

    /* fallback 舊版 prop，確保萬無一失 */
    fillShadowGradient: Palette.primary,
    fillShadowGradientOpacity: 1,

    color: () => Palette.primary,       // Bar color
    labelColor: () => '#000',           // Label color
    propsForBackgroundLines: {
        stroke: '#ccc',
    },
};
const chartConfig2 = {
    backgroundColor: '#fff',
    backgroundGradientFrom: '#fff',
    backgroundGradientTo: '#fff',
    color: () => Palette.primary,
    labelColor: () => '#000',
    decimalPlaces: 0,
    barPercentage: 0.6, // Bar width
}

const EditModal = ({ isVisible, onClose, onSubmit, value }: { isVisible: boolean; onClose: () => void; onSubmit: (newValue: string) => void; value: string }) => (
    <Modal
        isVisible={isVisible}
        onBackdropPress={onClose}
        backdropOpacity={0.1}
        animationIn="slideInUp"
        animationOut="slideOutDown"
    // style={{
    //     margin: 0,
    //     position: 'absolute',
    //     top: modalPosition.y,
    //     left: modalPosition.x
    // }}
    >
        <View className="flex-1 bg-white p-6 rounded-t-3xl">
            {/* Header */}
            <View className="flex-row justify-between items-center mb-4">
                <Text className="text-xl font-bold">編輯內容</Text>
                <Pressable onPress={onClose}>
                    <Text className="text-gray-400 text-base">關閉</Text>
                </Pressable>
            </View>

            {/* Input Field */}
            <TextInput
                value={value}
                onChangeText={() => {}}
                placeholder="請輸入內容"
                className="border border-gray-300 rounded p-3 text-base"
            />

            {/* Save Button */}
            <Pressable
                onPress={() => {}}
                className="mt-6 bg-blue-500 py-3 rounded"
            >
                <Text className="text-white text-center font-semibold">儲存</Text>
            </Pressable>


            {/* <TextInput
                style={{
                    borderWidth: 1,
                    borderColor: 'gray',
                    borderRadius: 5,
                    padding: 8,
                    marginBottom: 10,
                }}
                placeholder="輸入新名稱"
                // value={newTitle}
                // onChangeText={setNewTitle}
            />
            <Text style={{ fontSize: 18, fontWeight: 'bold', marginBottom: 10, textAlign: 'center' }}>
                {selectedConversation?.title}
            </Text>

            <Pressable
                onPress={() => {}}
                style={{ padding: 10, flexDirection: 'row', alignItems: 'center', marginBottom: 10 }}
            >
                <MaterialIcons name="delete" size={20} color="red" />
                <Text style={{ marginLeft: 10, color: 'red' }}>刪除</Text>
            </Pressable>

            <Pressable
                onPress={() => {}}
                style={{ padding: 10, flexDirection: 'row', alignItems: 'center', marginBottom: 10 }}
            >
                <Feather name="check" size={20} color="blue" />
                <Text style={{ marginLeft: 10, color: 'blue' }}>確認</Text>
            </Pressable>
            <Pressable
                onPress={() => {}} // 顯示輸入框
                style={{ padding: 10, flexDirection: 'row', alignItems: 'center', marginBottom: 10 }}
            >
                <Feather name="edit" size={20} color="blue" />
                <Text style={{ marginLeft: 10, color: "blue" }}>重新命名</Text>
            </Pressable>
            <Pressable
                onPress={onClose}
                style={{ padding: 10, flexDirection: 'row', alignItems: 'center' }}
            >
                <MaterialIcons name="cancel" size={20} color="gray" />
                <Text style={{ marginLeft: 10, color: 'gray' }}>取消</Text>
            </Pressable> */}
        </View>
    </Modal>
);

export default function ElectricityScreen() {
    const [values, setValues] = useState(Array(12).fill("")); // TODO
    const [included, setIncluded] = useState(Array(12).fill(true));
    // Modal
    const [isVisibleModal, setIsVisibleModal] = useState(false); // TODO

    const toggleIncluded = (index: number) => {
        const newIncluded = [...included];
        newIncluded[index] = !newIncluded[index];
        setIncluded(newIncluded);
    };
    const handleEdit = (index: number) => {
        setIsVisibleModal(true);
    };
    const onCloseModal = () => {
        setIsVisibleModal(false);
    };

    return (
        <ScrollView className="px-4">
            <Text className='text-xl font-bold py-4'>電力使用管理</Text>
            <View className="border border-gray-300 rounded-lg overflow-hidden mb-8">
                {/* Header */}
                <View className="flex-row bg-gray-200 py-2">
                    <Text className="w-[10%] text-center font-bold">統計</Text>
                    <Text className="w-[30%] text-center font-bold">月份</Text>
                    <Text className="w-[60%] text-center font-bold">用電量 (kWh)</Text>
                </View>
                {/* Rows */}
                {months.map((month, i) => (
                    <View
                        key={i}
                        className={`flex-row items-center border-t border-gray-300 ${i % 2 === 0 ? "bg-white" : "bg-gray-50"}`}
                    >
                        {/* Checkbox */}
                        <View className="w-[10%] items-center">
                            <Checkbox
                                value={included[i]}
                                onValueChange={() => toggleIncluded(i)}
                                color={included[i] ? Palette.primary : undefined}
                            />
                        </View>

                        {/* Month */}
                        <Text className="w-[30%] text-center">{month}</Text>

                        {/* Value + Edit */}
                        <View className="w-[60%] flex-row items-center justify-center px-2">
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
            <View className="border border-[#E3E3E3] rounded-xl bg-white overflow-hidden p-4 mb-8">
                <Text className="text-xl font-bold">電力排放量</Text>
                <View className="flex-row items-center justify-end mb-2 space-x-3">
                    <View className="flex-row items-center">
                        <View className="w-4 h-4 rounded bg-blue-400 mr-1" />
                        <Text className="text-xs">排放量</Text>
                    </View>
                </View>
                <BarChart
                    data={{
                            labels: rows.filter(r => r.checked).map(r => `${r.month + 1} 月`),
                            datasets: [
                                {
                                    data: rows.filter(r => r.checked).map(r => r.consumption),
                                    color: () => '#f0f' // Palette.primary,
                                },
                            ],
                        }}
                    width={Dimensions.get('window').width - 32} // minus padding
                    height={240}
                    fromZero
                    yAxisSuffix="度"
                    chartConfig={chartConfig}
                />
            </View>
            {/* <BarChart
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
            /> */}
        </ScrollView>
    );
}
