require "debug"

local CircuitNetwork = {}

--- Return the specified signal from the wire
--- @param control the control behavior
--- @param wire the red or green wire to get the signals from. @see defines.wire_type
--- @param circuit_connector input or output of the circuit control network @see defines.circuit_connector_id
--- @return all signals from the specified wire and circuit connector
function get_signals(control, wire, circuit_connector)
    if wire ~= defines.wire_type.red and wire ~= defines.wire_type.green then
        logw("Invalid wire type: " .. wire)
        return
    end
    if circuit_connector ~= defines.circuit_connector_id.combinator_input and circuit_connector ~= defines.circuit_connector_id.combinator_output then
        logw("Invalid circuit_connector_id: " .. circuit_connector)
        return
    end

    local circuit_network = control.get_circuit_network(wire, circuit_connector)
    if circuit_network then
        return circuit_network.signals
    end
end

--- Add signal to the specified array. If the signal already exists it will add that result
--- @param from the signal array to add from
--- @param to the array to add to
--- @param filters (optional) filters. Only these signal will be added to the 'to' table
function add_signals(from, to, filters)
    for k, signal_container in pairs(from) do
        local signal = signal_container.signal
        local id = signal.name
        local count = signal_container.count
        local add_signal = true
        if filters then
            if filters[id] == nil then
                logd("Don't use signal: " .. id)
                add_signal = false
            else
                logd("Use signal: " .. id)
            end
        end
        if add_signal then
            if to[id] ~= nil then
                logd("Updating count to " .. (to[id].count + count))
                to[id].count = to[id].count + count
            else
                local signal_info = {
                    signal = signal,
                    count = count,
                }
                to[id] = signal_info
            end
        end
    end
end

--- Return the input from a control
--- @param input_combinator the (input) Enhanced Combinator to get all the input signal from
--- @param filters (optional) filters for the input signals
--- @return all signal inputs for the combinator
function CircuitNetwork.get_input(input_combinator, filters)
    local control = input_combinator.get_control_behavior()
    local red_input = get_signals(control, defines.wire_type.red, defines.circuit_connector_id.combinator_input)
    local green_input = get_signals(control, defines.wire_type.green, defines.circuit_connector_id.combinator_input)

    -- Add inputs from both wires
    local input = {}
    if red_input then
        add_signals(red_input, input, filters)
    end
    if green_input then
        add_signals(green_input, input, filters)
    end

    return input
end

--- Set the output signal of the control parameters
--- @param output_combinator the Enhanced output combinator to change the output signal for
--- @param output_signal new output_signal
--- @param count the count of the new output_signal
function CircuitNetwork.set_output_signal(output_combinator, output_signal, count)
    CircuitNetwork.clear_output_signals(output_combinator, 1)
    local control = output_combinator.get_control_behavior()
    local output = {
        signal = output_signal,
        count = count,
    }
    control.set_signal(1, output)
end

--- Clears all or a specific number of output signals
--- @param output_combinator the Enhanced output combinator to clear
--- @param number the number of fields to clear, if not specified defaults to all
function CircuitNetwork.clear_output_signals(output_combinator, number)
    local control = output_combinator.get_control_behavior()
    local count = control.signals_count
    if number then
        count = number
    end
    for i = 1, count do
        control.set_signal(i, nil)
    end
end

--- Set the operation of the combinator
--- @param control the arithmetic combinator control behavior to set the operation for
--- @param operation new operation for the combinator
function CircuitNetwork.set_operation(control, operation)
    local new_parameters = control.parameters.parameters
    new_parameters.operation = operation
    control.parameters = {
        parameters = new_parameters
    }
end

return CircuitNetwork