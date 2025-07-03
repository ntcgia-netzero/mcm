import { View, Text, TextInput, Pressable, SafeAreaView, KeyboardAvoidingView, Platform, Alert, ScrollView } from "react-native";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { router } from "expo-router";
import { z } from "zod";

// Zod schema 定義
const emissionSchema = z.object({
    electricity: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
        message: "請輸入有效的用電量"
    }),
    fuel: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
        message: "請輸入有效的燃料用量"
    }),
    refrigerant: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
        message: "請輸入有效的冷媒量"
    }),
    transportation: z.string().refine(val => !isNaN(Number(val)) && Number(val) >= 0, {
        message: "請輸入有效的員工交通排放量"
    }),
});

type EmissionFormValues = z.infer<typeof emissionSchema>;

export default function CarbonScreen() {
    const insets = useSafeAreaInsets();

    const {
        register,
        setValue,
        handleSubmit,
        formState: { errors, isSubmitting }
    } = useForm<EmissionFormValues>({
        resolver: zodResolver(emissionSchema),
        defaultValues: {
            electricity: "",
            fuel: "",
            refrigerant: "",
            transportation: "",
        },
    });

    const onSubmit = async (data: EmissionFormValues) => {
        try {
            console.log("填報資料", data);
            // 🔗 TODO: 這裡可以用 fetch() POST 給 FastAPI
            Alert.alert("成功", "已送出綠能碳排資料");
            router.replace("/test-minimal"); // 提交後跳轉
        } catch (err) {
            Alert.alert("失敗", "提交失敗，請稍後再試");
        }
    };

    return (
        <SafeAreaView
            className="flex-1 bg-white"
            style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}
        >
            <KeyboardAvoidingView
                className="flex-1 px-6"
                behavior={Platform.OS === "ios" ? "padding" : "height"}
            >
                <ScrollView
                    className="flex-1"
                    keyboardShouldPersistTaps="handled"
                    contentContainerStyle={{ paddingVertical: 40 }}
                >
                    <Text className="text-2xl font-bold mb-6 text-black">綠能碳排填報</Text>

                    {/* 用電量 */}
                    <View className="mb-4">
                        <Text className="mb-1 text-gray-700">用電量 (kWh)</Text>
                        <TextInput
                            className="border-b border-gray-300 py-3"
                            keyboardType="numeric"
                            placeholder="輸入用電量"
                            onChangeText={(text) => setValue("electricity", text)}
                            {...register("electricity")}
                        />
                        {errors.electricity && (
                            <Text className="text-red-500 text-xs">{errors.electricity.message}</Text>
                        )}
                    </View>

                    {/* 燃料用量 */}
                    <View className="mb-4">
                        <Text className="mb-1 text-gray-700">燃料用量 (公升)</Text>
                        <TextInput
                            className="border-b border-gray-300 py-3"
                            keyboardType="numeric"
                            placeholder="輸入燃料用量"
                            onChangeText={(text) => setValue("fuel", text)}
                            {...register("fuel")}
                        />
                        {errors.fuel && (
                            <Text className="text-red-500 text-xs">{errors.fuel.message}</Text>
                        )}
                    </View>

                    {/* 冷媒使用量 */}
                    <View className="mb-4">
                        <Text className="mb-1 text-gray-700">冷媒使用量 (kg)</Text>
                        <TextInput
                            className="border-b border-gray-300 py-3"
                            keyboardType="numeric"
                            placeholder="輸入冷媒使用量"
                            onChangeText={(text) => setValue("refrigerant", text)}
                            {...register("refrigerant")}
                        />
                        {errors.refrigerant && (
                            <Text className="text-red-500 text-xs">{errors.refrigerant.message}</Text>
                        )}
                    </View>

                    {/* 員工交通排放量 */}
                    <View className="mb-4">
                        <Text className="mb-1 text-gray-700">員工交通排放量 (kg CO₂)</Text>
                        <TextInput
                            className="border-b border-gray-300 py-3"
                            keyboardType="numeric"
                            placeholder="輸入員工交通排放量"
                            onChangeText={(text) => setValue("transportation", text)}
                            {...register("transportation")}
                        />
                        {errors.transportation && (
                            <Text className="text-red-500 text-xs">{errors.transportation.message}</Text>
                        )}
                    </View>

                    {/* 送出按鈕 */}
                    <Pressable
                        className={`mt-8 py-4 rounded-xl ${isSubmitting ? "bg-gray-300" : "bg-black"}`}
                        disabled={isSubmitting}
                        onPress={handleSubmit(onSubmit)}
                    >
                        <Text className="text-center text-white text-base font-semibold">
                            {isSubmitting ? "送出中..." : "送出填報"}
                        </Text>
                    </Pressable>
                </ScrollView>
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
}
